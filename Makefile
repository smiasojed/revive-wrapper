.PHONY: pack-revive install-wasm all clean
RELEASE_DIR := ./target/wasm32-unknown-emscripten/release

pack-revive:
	@echo "Create soljson.js..."
	@mkdir -p upload
	./pack_soljson.sh "$(RELEASE_DIR)/revive-wrapper.js" "$(RELEASE_DIR)/revive_wrapper.wasm" upload/soljson.js

RUSTFLAGS_EMSCRIPTEN := \
	-Clink-arg=-sEXPORTED_FUNCTIONS='["_solidity_license","_solidity_version","_solidity_compile","_solidity_alloc","_solidity_free","_solidity_reset"]' \
	-Clink-arg=-sEXIT_RUNTIME=0 \
	-Clink-arg=-sFILESYSTEM=0 \
	-Clink-arg=-sALLOW_MEMORY_GROWTH=1 \
	-Clink-arg=-sERROR_ON_UNDEFINED_SYMBOLS=1 \
	-Clink-arg=-sWASM=1 \
	-Clink-arg=-sWASM_ASYNC_COMPILATION=0 \
	-Clink-arg=-sALLOW_TABLE_GROWTH=1 \
	-Clink-arg=-sASSERTIONS=0 \
	-Clink-arg=-sDISABLE_EXCEPTION_CATCHING=1 \
	-Clink-arg=-sNODEJS_CATCH_EXIT=0 \
	-Clink-arg=-sDYNAMIC_EXECUTION=0 \
	-Clink-arg=-sSTRICT_JS=1 \
	-Clink-arg=-sEXPORTED_RUNTIME_METHODS=['cwrap','addFunction','removeFunction','UTF8ToString','lengthBytesUTF8','stringToUTF8','setValue']
	# -Clink-arg=-sSTRICT=1
	# -Clink-arg=-sEXPORTED_FUNCTIONS=_main,_free,_malloc,_solidity_version,_solidity_license,_solidity_compile,_solidity_reset,_solidity_free \
	# -Clink-arg=-sWASM=1  -Clink-arg=-sWASM_ASYNC_COMPILATION=0  -Clink-arg=-sSINGLE_FILE=1 \
	# -Clink-arg=-sNO_INVOKE_RUN \
	# -Clink-arg=-sEXIT_RUNTIME \
	# -Clink-arg=-sINITIAL_MEMORY=64MB \
	# -Clink-arg=-sALLOW_MEMORY_GROWTH \
	# -Clink-arg=-sEXPORTED_RUNTIME_METHODS=FS,callMain,stringToNewUTF8 \
	# -Clink-arg=-sMODULARIZE \
	# -Clink-arg=-sEXPORT_ES6

install-wasm:
	RUSTFLAGS='$(RUSTFLAGS_EMSCRIPTEN)' cargo install --target wasm32-unknown-emscripten --path ./

clean:
	cargo clean
	rm ./upload/soljson.js

all: install-wasm pack-revive
