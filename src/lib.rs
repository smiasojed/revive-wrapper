use libc::size_t;
use std::ffi::{CStr, CString, c_char};
use std::ptr;

#[no_mangle]
pub extern "C" fn solidity_license() -> *const c_char {
    let license = "This is the Solidity license.";
    CString::new(license).unwrap().into_raw()
}

#[no_mangle]
pub extern "C" fn solidity_version() -> *const c_char {
    let version = "0.8.10";
    CString::new(version).unwrap().into_raw()
}

#[no_mangle]
pub extern "C" fn solidity_alloc(size: size_t) -> *mut c_char {
    let buffer = vec![0u8; size].into_boxed_slice();
    Box::into_raw(buffer) as *mut c_char
}

#[no_mangle]
pub extern "C" fn solidity_free(data: *mut c_char) {
    if !data.is_null() {
        unsafe {
            CString::from_raw(data);
        }
    }
}

#[no_mangle]
pub extern "C" fn solidity_compile(
    input: *const c_char,
    _readCallback: Option<extern "C" fn(*mut libc::c_void, *const c_char, *const c_char, *mut *mut c_char, *mut *mut c_char)>,
    _readContext: *mut libc::c_void,
) -> *mut c_char {
    let input = unsafe { CStr::from_ptr(input).to_str().unwrap_or("") };

    // Mock compilation process
    let output = format!("Compiled output for: {}", input);

    CString::new(output).unwrap().into_raw()
}

#[no_mangle]
pub extern "C" fn solidity_reset() {
    // Since we are not maintaining any global state, nothing needs to be done here.
}