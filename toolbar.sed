
/^HKEY[^\]*\\[^\]*\\[^\]*($|\\(progid|typelib|versionindependentprogid|InprocServer32)$)|<no name>.*\t.*\t[^$]|\(Default\)    REG_\S*    [^$]/I!d

/^HKEY.*\}$/Is//\n&/p;

/^HKEY.*typelib$/I{
	n
	/^ +<no name>.*\t/Is//HKEY_CLASSES_ROOT\\TypeLib\\\1/p;
	/^    \(Default\)    REG_\S*    /s//HKEY_CLASSES_ROOT\\TypeLib\\/p;
	}

/^HKEY.*versionindependentprogid$/I{
	n;
	/^ +<no name>.*\t/Is//HKEY_CLASSES_ROOT\\\1/p;
	/^    \(Default\)    REG_\S*    /s//HKEY_CLASSES_ROOT\\/p;
	}

/^HKEY.*progid$/I{
	n;
	/^ +<no name>.*\t/Is//HKEY_CLASSES_ROOT\\\1/p
	/^    \(Default\)    REG_\S*    /s//HKEY_CLASSES_ROOT\\/p;
	}
