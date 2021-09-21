# USEMG-feature-extraction

This repository provide the Matlab codes for feature extraction of sEMG and A-mode ultrasound signals.

![USEMG_featureExtraction](/figures/USEMG_featureExtraction.png)
(Picture taken from [Feature Fusion of sEMG and Ultrasound Signals in Hand Gesture Recognition](https://ieeexplore.ieee.org/abstract/document/9282818/))

* Work to be accomplished:
    * [ ] change to user-friendly function interface for facilitating external call
    * [ ] implement the python version


## Introduction
TD-AR6 features are employed as the sEMG feature and MSD features are employed as the A-mode ultrasound (AUS) feature.

## Environment
The codes are running with Matlab 2017b on Windows 10.

## Data preparing
We provide the sEMG samples and AUS samples of one subject for code testing, which can be downloaded from:

*   [Baidu Disk](https://pan.baidu.com/s/1Tc9Y6TTDm7xjjOsoLFioqA) (code: pyc4).


## Quick Start
### Installation
1. Clone this repo
2. Create a folder named by "dataset". Download the dataset from the link and place it in this folder.

### Feature Extraction
* Extract sEMG features
  ```
  cd extractEMGFeature
  extractEMGFeature
  ```
* Extract AUS features
  ```
  cd exactUSFeature
  main
  ```
The extracted features will be saved to a folder named "featureset" (automatically create if not exits)

## Contact
If you have any questions, feel free to contact me through jia.zeng@sjtu.edu.cn or Github issues.