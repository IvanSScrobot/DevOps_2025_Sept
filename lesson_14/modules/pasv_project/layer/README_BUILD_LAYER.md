# Build the Pillow Lambda Layer (Amazon Linux 2023)

1) SSH into any Amazon Linux 2023 instance (EC2 in this project works fine).
2) Run:

```bash
mkdir -p ~/pillow-layer/python/lib/python3.12/site-packages
python3 -m pip install --upgrade pip
python3 -m pip install pillow -t ~/pillow-layer/python/lib/python3.12/site-packages
cd ~/pillow-layer
zip -r9 pillow-layer.zip python
```

3) Copy ~/pillow-layer/pillow-layer.zip to your local machine and set the Terraform variable:
```
# when applying
terraform apply -var="pillow_layer_zip=/path/to/pillow-layer.zip"
```
