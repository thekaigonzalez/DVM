import std.stdio;
import std.array;
import std.file : read;
import std.string;
import std.algorithm;
static import core.exception;
import std.conv;

/// Basic Conversion Function.

/// A type for a register,
/// These are enumerated at runtime.
enum RegType
{
	REG_PRINT,
	REG_ADD,
	REG_EXIT
}

/// **Register**
///
/// A register based on a RegType,
/// This will convert it into a better readable/understandable type.
class VRegister
{
	RegType internal_type;
	string[] arg;

public:
	this(RegType t, string[] a)
	{
		internal_type = t;
		arg = a;
	}

	/// Return the internal type of the register.
	RegType getInternal()
	{
		return internal_type;
	}

	/// Return the arguments of the register.
	string[] getArguments()
	{
		return arg;
	}
}

/// Utility Function to check a member of an array.
string vl_checkarg(string[] arr, int idx) {
	try {
		return arr[idx];
	}
	catch(core.exception.ArrayIndexError e) {
		return "-1";
	}
}

/// Authors: Kai D. Gonzalez
///	Returns: a VM.
/// See_Also: VRegister, RegType
///
/// **The VM class**
/// 
/// () => Initialize a new VM.
///
/// You can execute multiple statements using `execute()`
class DL_VM
{
public:
	this()
	{
	}

	int execute(VRegister[] reglist)
	{
		int CODE = 0;
		foreach (VRegister s; reglist)
		{
			switch (s.getInternal)
			{

			case RegType.REG_PRINT:

				writeln(vl_checkarg(s.getArguments(), 0));

				break;
			case RegType.REG_ADD:
				string[] args = s.getArguments();

				int first = to!int(vl_checkarg(args, 0));
				int next = to!int(vl_checkarg(args, 1));

				CODE = first + next;

				break;
			case RegType.REG_EXIT:
				CODE = (to!int(vl_checkarg(s.getArguments(), 0)));
				return CODE;
			default:
				CODE = -1;
				break;
			}

		}
		return CODE;
	}

}

void ExecuteReg(DL_VM vm, RegType t, string[] args = [])
{
	try
	{
		auto reg = new VRegister(t, args); // create new register - REG_PRINT [args]

		// create list based on one register, from the type and arguments.
		auto reglist = [reg];

		// print the result, if it's an `add` operation, it will return the result.
		// same goes for any other operations i add down the line.
		writeln(to!string(vm.execute(reglist)));
	}
	catch (Exception)
	{
		writeln("builtin exception occured while trying to execute statement.\nmake sure all parameters are supplied correctly.");

	}
}

void runCodeForParse(DL_VM vm, string[] txts)
{
	if (txts.length == 0)
		return;
	if (!txts[0].startsWith("//"))
	{
		if (txts[0] == "print")
		{
			ExecuteReg(vm, RegType.REG_PRINT, txts.remove(0));
		}
		else if (txts[0] == "add")
		{
			ExecuteReg(vm, RegType.REG_ADD, txts.remove(0));
		}

		else if (txts[0] == "bulk")
		{
			// Run File
			string[] lines = split(cast(string) read(txts[1]), "\n"); // line by line

			foreach (string line; lines) // execute each line
				runCodeForParse(vm, line.split(" "));
		}

		else if (txts[0] == "exit") {
			ExecuteReg(vm, RegType.REG_EXIT, txts.remove(0));
		}

		else
		{
			writeln("Not a valid command, `" ~ txts[0] ~ "'"); // no command called that name
		}
	}
}

/// tests...
void test1() {
	DL_VM vm1 = new DL_VM();
	vm1.execute([new VRegister(RegType.REG_PRINT, ["hello!"])]);
}

void main()
{
	writeln("The D VM");
	writeln("Type commands and they'll be converted to a register for the VM.");
	writeln("Sample Registers:");
	writeln("print hello world - REG_PRINT [hello, world] (hello world)\n");

	DL_VM myvm = new DL_VM();

	test1();

	while (true)
	{
		write(">> ");

		string txt = readln().strip;
		string[] txts = txt.split(" ");

		runCodeForParse(myvm, txts);
	}
}
