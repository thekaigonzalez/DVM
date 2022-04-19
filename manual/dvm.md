# DVM

A Virtual Machine which takes requests.

## Register Class

The Register class "VRegister", is a class which holds a type, and a list of arguments.

When this is passed to the virtual machine, it is loaded into \<OPERATION> \<ARGS>, and ran as such.

Types are called REG_ADD, REG_PRINT, AND REG_EXIT (under construction)

## RegType (Register Type)

The register type is an enumerated flag to tell the vm what to do with the given arguments.

## VM Class

The VM Class usually wrapped around for readability, but as an example:

```dlang

DL_VM vm1 = new DL_VM();
vm1.execute([new VRegister(RegType.REG_PRINT, ["hello!"])]);

```

Would print:

```
hello!
```

But you would most of the time wrap it around an instance function to run commands easier.

## Gathering Operations

The Virtual Machine gathers operations like this (reglist as [register list](#register-class), and getInternal as the [regType](#regtype-register-type)):

```dlang

foreach (VRegister s; reglist)
		{
			switch (s.getInternal)
			{

```

This code gives the program a type, which is then enumerated as so.

```dlang

case RegType.REG_PRINT:
case RegType.REG_ADD:
case RegType.REG_EXIT:

```

## Specifics

With this version of the DVM, `bulk` is currently implemented as a custom command, not officially supported by the VM.

If you have any other versions, and want to use the `bulk()` function, please ensure the version contains a definition 
for `bulk()`, by reading it's documentation.