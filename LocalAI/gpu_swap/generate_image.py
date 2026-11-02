"""Generate one Flux3 klein image through a running ComfyUI and print the result as JSON."""
import argparse
import json
import sys
import time
import urllib.request

BASE_URL = "http://127.0.0.1:8188"


def request_json(path, payload=None):
    data = json.dumps(payload).encode("utf-8") if payload is not None else None
    headers = {"Content-Type": "application/json"} if data else {}
    with urllib.request.urlopen(urllib.request.Request(BASE_URL + path, data=data, headers=headers), timeout=120) as r:
        return json.load(r)


def workflow(prompt, width, height, seed, steps, prefix):
    return {
        "1": {"class_type": "UNETLoader", "inputs": {"unet_name": "flux3-image-klein-int8-convrot.safetensors", "weight_dtype": "default"}},
        "2": {"class_type": "CLIPLoader", "inputs": {"clip_name": "qwen3vl_4b_int8_convrot.safetensors", "type": "flux3", "device": "default"}},
        "3": {"class_type": "VAELoader", "inputs": {"vae_name": "flux2-vae.safetensors"}},
        "4": {"class_type": "CLIPTextEncode", "inputs": {"clip": ["2", 0], "text": prompt}},
        "5": {"class_type": "CLIPTextEncode", "inputs": {"clip": ["2", 0], "text": ""}},
        "6": {"class_type": "EmptyFlux2LatentImage", "inputs": {"width": width, "height": height, "batch_size": 1}},
        "7": {"class_type": "KSampler", "inputs": {"model": ["1", 0], "seed": seed, "steps": steps, "cfg": 1.0,
                                                   "sampler_name": "euler", "scheduler": "simple", "positive": ["4", 0],
                                                   "negative": ["5", 0], "latent_image": ["6", 0], "denoise": 1.0}},
        "8": {"class_type": "VAEDecode", "inputs": {"samples": ["7", 0], "vae": ["3", 0]}},
        "9": {"class_type": "SaveImage", "inputs": {"images": ["8", 0], "filename_prefix": prefix}},
    }


def reference_workflow(prompt, refs, megapixels, seed, steps, prefix):
    """Same graph as ワークフロー/画像生成ワークフロー（元画像あり）.json. refs are file names in ComfyUI/input.

    ReferenceMultiLatent feeds the images to the model; the prompt points at them as <ref_image_0>, <ref_image_1>...
    The output size follows the first reference's aspect ratio at the given megapixels."""
    graph = {
        "1": {"class_type": "UNETLoader", "inputs": {"unet_name": "flux3-image-klein-int8-convrot.safetensors", "weight_dtype": "default"}},
        "2": {"class_type": "CLIPLoader", "inputs": {"clip_name": "qwen3vl_4b_int8_convrot.safetensors", "type": "flux3", "device": "default"}},
        "3": {"class_type": "VAELoader", "inputs": {"vae_name": "flux2-vae.safetensors"}},
        "4": {"class_type": "CLIPTextEncode", "inputs": {"clip": ["2", 0], "text": prompt}},
        "5": {"class_type": "ConditioningZeroOut", "inputs": {"conditioning": ["4", 0]}},
        "7": {"class_type": "ReferenceMultiLatent", "inputs": {"positive": ["4", 0], "negative": ["5", 0], "vae": ["3", 0],
                                                               "resolution": "resize", "resolution.megapixels": megapixels}},
        "8": {"class_type": "KSampler", "inputs": {"model": ["1", 0], "seed": seed, "steps": steps, "cfg": 1.0,
                                                   "sampler_name": "euler", "scheduler": "simple", "positive": ["7", 0],
                                                   "negative": ["7", 1], "latent_image": ["7", 2], "denoise": 1.0}},
        "9": {"class_type": "VAEDecode", "inputs": {"samples": ["8", 0], "vae": ["3", 0]}},
        "10": {"class_type": "SaveImage", "inputs": {"images": ["9", 0], "filename_prefix": prefix}},
    }
    for i, name in enumerate(refs):
        node = str(20 + i)
        graph[node] = {"class_type": "LoadImage", "inputs": {"image": name}}
        graph["7"]["inputs"][f"images.image{i}"] = [node, 0]
    return graph


def main():
    p = argparse.ArgumentParser()
    src = p.add_mutually_exclusive_group(required=True)
    src.add_argument("--prompt")
    src.add_argument("--prompt-file", help="UTF-8 text file with the prompt")
    p.add_argument("--width", type=int, default=1024)
    p.add_argument("--height", type=int, default=1024)
    p.add_argument("--seed", type=int, default=int(time.time()) % 2**31)
    p.add_argument("--steps", type=int, default=16)
    p.add_argument("--prefix", default="gpu-swap")
    p.add_argument("--timeout", type=int, default=1800)
    p.add_argument("--ref", action="append", default=[], help="reference image name in ComfyUI/input (up to 3)")
    a = p.parse_args()
    if a.prompt_file:
        with open(a.prompt_file, encoding="utf-8-sig") as f:
            a.prompt = f.read()

    if a.ref:
        graph = reference_workflow(a.prompt, a.ref[:3], round(a.width * a.height / 1_000_000, 2), a.seed, a.steps, a.prefix)
    else:
        graph = workflow(a.prompt, a.width, a.height, a.seed, a.steps, a.prefix)
    prompt_id = request_json("/prompt", {"prompt": graph})["prompt_id"]
    deadline = time.monotonic() + a.timeout
    while time.monotonic() < deadline:
        record = request_json("/history/" + prompt_id).get(prompt_id)
        if record:
            status = record.get("status", {})
            if status.get("completed"):
                images = [img for out in record.get("outputs", {}).values() for img in out.get("images", [])]
                print(json.dumps({"ok": True, "prompt_id": prompt_id, "seed": a.seed, "images": images}))
                return 0
            if any(m[0] == "execution_error" for m in status.get("messages", [])):
                print(json.dumps({"ok": False, "prompt_id": prompt_id, "error": status}))
                return 2
        time.sleep(1)
    print(json.dumps({"ok": False, "prompt_id": prompt_id, "error": "timeout"}))
    return 3


if __name__ == "__main__":
    sys.exit(main())
