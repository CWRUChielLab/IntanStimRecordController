# Run with nmake, mingw32-make, or similar
# Assumes Windows 64-bit

BUILD_DIR  	= build
BUILD_TYPE 	= release
EXEC_FILE  	= IntanStimRecordController.exe
DEPLOY_DIR 	= $(BUILD_DIR)\$(BUILD_TYPE)-deploy
BUILD_EXEC 	= $(BUILD_DIR)\$(BUILD_TYPE)\$(EXEC_FILE)
DEPLOY_EXEC	= $(DEPLOY_DIR)\$(EXEC_FILE)

COPY_FILE = copy /y
MKDIR     = mkdir
DEL_DIR   = rmdir /s

first: $(DEPLOY_EXEC)

$(BUILD_EXEC): FORCE
	if not exist $(BUILD_DIR) $(MKDIR) $(BUILD_DIR)
	cd $(BUILD_DIR)
	qmake ..\source\IntanStimRecordController.pro
	$(MAKE) $(BUILD_TYPE)
	cd ..

$(DEPLOY_DIR)\main.bit:
	if not exist $(DEPLOY_DIR) $(MKDIR) $(DEPLOY_DIR)
	$(COPY_FILE) main.bit $(DEPLOY_DIR)

$(DEPLOY_DIR)\okFrontPanel.dll:
	if not exist $(DEPLOY_DIR) $(MKDIR) $(DEPLOY_DIR)
	$(COPY_FILE) "Opal Kelly library files\Windows 64-bit\okFrontPanel.dll" $(DEPLOY_DIR)

$(DEPLOY_DIR)\license.txt:
	if not exist $(DEPLOY_DIR) $(MKDIR) $(DEPLOY_DIR)
	$(COPY_FILE) license\license.txt $(DEPLOY_DIR)

$(DEPLOY_DIR)\gpl.txt:
	if not exist $(DEPLOY_DIR) $(MKDIR) $(DEPLOY_DIR)
	$(COPY_FILE) license\gpl.txt $(DEPLOY_DIR)

$(DEPLOY_DIR)\README.txt: FORCE
	if not exist $(DEPLOY_DIR) $(MKDIR) $(DEPLOY_DIR)
	echo Source code: > $@
	echo https://github.com/CWRUChielLab/IntanStimRecordController >> $@
	echo. >> $@
	echo Version: >> $@
	git describe --tags >> $@
	echo. >> $@
	echo Revision: >> $@
	git rev-parse HEAD >> $@
	echo. >> $@
	echo Build: >> $@
	echo Windows 64-bit ($(BUILD_TYPE)) >> $@

$(DEPLOY_EXEC): $(BUILD_EXEC) \
				$(DEPLOY_DIR)\main.bit \
				$(DEPLOY_DIR)\okFrontPanel.dll \
				$(DEPLOY_DIR)\license.txt \
				$(DEPLOY_DIR)\gpl.txt \
				$(DEPLOY_DIR)\README.txt
	windeployqt --dir $(DEPLOY_DIR) $(BUILD_EXEC)
	$(COPY_FILE) $(BUILD_EXEC) $(DEPLOY_DIR)

clean: FORCE
	if exist $(BUILD_DIR) $(DEL_DIR) $(BUILD_DIR)

FORCE:
