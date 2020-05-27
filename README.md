# 3D-sound-synthesis
### Goal
Binaural synthesis for reproduction spatial of audio signals.

### Database
PKU-IOA-HRTF database 65536 Hz (http://www.cis.pku.edu.cn/auditory/Staff/Dr.Qu.files/Qu-HRTFDatabase.html). You can put the files into the folder.

### Pipeline
1. Generating offline info (HRTF coordinates -> tetrahedral mesh -> octree generation)
2. Select or draw function representing the source movement from Matlab GUI
3. Interpolate the HRIR-Left and HRIR-Right using database and octree
4. Merge the HRIR and write the new 3D audio

### To run
Change the path in ProjectGUI.m (395-400) and HRIR_interpolation (74-76).
```
Run from ProjectGUI.m file
```
Resampling the database to lower quality to improve performance with:
```
resampling_db.m
```

### Matlab GUI Preview

![]()



### Requirements
| Software  | Version | Required|
| ------------- | ------------- |  ------------- |
| Matlab | >= R2019a  | Yes    |
