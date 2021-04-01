# Google Landmark Recognition 2019
This is my solution for the [Google Landmark Recognition 2019](https://www.kaggle.com/c/landmark-recognition-2019) competition hosted on Kaggle.  This solution placed 50th (out of 281).

## Hardware
Training and inference were done on entirely on AWS (1xK80).

## Data
All images were downsampled to 256x256 using imgp.

## Training and Inference
An EC2 instance can be provisioned and setup easily by running:
```bash
./setup/setup.sh ${KEY_NAME} ${SG_ID} ${SUBNET_ID} ${LOCAL_DATA_DIR}
```
`LOCAL_DATA_DIR` is optional and just uses scp to upload data to your EC2 instance if you have data stored locally.

Data can be retrieved either locally or remotely using:
```bash
./setup/get_data.sh
```

Both training and inference are handled with:
```python
python train_and_inference.py
```
This script was influenced by @artyomp's work.<sup>1</sup>  The script will generate a submission.csv file which can then be submitted. 

## Credits
1. [@artyomp resnet50 baseline](https://www.kaggle.com/artyomp/resnet50-baseline)