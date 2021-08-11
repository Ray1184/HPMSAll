@echo HPMS Project Builder - Copyright(c) 2020

blender --background %cd%/../batch/input/HPMSScene.blend --python %cd%/../batch/bdata/main.py --log-level 0 -- --logging-level TRACE --output %cd%/../batch/output/HPMS_Project --roomupdate-all yes --render yes --preview yes
pause