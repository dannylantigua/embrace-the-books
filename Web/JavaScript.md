# JavaScript Notes - Based on JavaScript: Novice to Ninja, 2nd Edition #

## Chapter 1 - Hello JavaScript ##
This chapter is just backgrouns and discussed the history of the language, versions, browser wars etc. It also mentions Node.js which was developed in 2009 and allows developers to write and run Javascript outside the browser and thus allows server side development as well as client side coding. There's been a huge rise in Single Page Applications (SPAs) which rely on JavaScript and the next step is evolution of Progressive Web Apps (PWAs) that use web technologies like HTML5, CSS and JavaScript frameworks to create desktop like experience on PCs and mobile devices (e.g. Windows desktop widgets, ChromeOS plugins, other browser extensions etc.). 

## Chapter 2 - Programming Basics ##
### Comments ###
	// this is a short comment

	/* This is a longer comment.
	Anything here will be ignored.
	This is a good place to write notes.
	*/

### JavaScript Grammar ###
JavaScript follows a C-style syntax. In JavaScript, each statement ends with a new line or semi-colon.  Technically, you don't need a semi-colon if you have a line break since the compiler is supposed to provide automatic semi-colon insertion.  In reality a number of tools including minifiers and validators don't handle this properly, so it is best practice to always finish a statement with a semi-colon.

This should be valid:

	const message = 'Hello World!'
	alert(message)

But in reality you would want to write this:

	const message = 'Hello World!';
	alert(message);

A code block does not need a semi-colon at the end.

	{
	// this is a block containing 2 statements
	const message = 'Hello!';
	alert(message);
	}

### Reserved Words ###

These include:

	abstract, await, boolean, break, byte, case, catch, char,
	class, const, continue, debugger, default, delete, do,
	double, else, enum, export, extends, false, final, finally,
	float, for, function, goto, if, implements, import, in,
	instanceof, int, interface, let, long, native, new, null,
	package, private, protected, public, return, short, static,
	super, switch, synchronized, this, throw, throws, transient,
	true, try, typeof, var, volatile, void, while, with, yield

Most of these are keywords in the language, but not all are.  Presumably those that aren't are reserved for potential future use.

There are a couple of words that should be reserved and are not, so be careful with these and don't use them for variable names.  They are:
	
	undefined, NaN, Infinity

### Primitive Data Types ###
There are 6 and they are:

- String 
- Symbol
- Number
- Boolean
- Undefined
- Null

Anything that is not primitive is an object including arrays, functions and object literals.

You can use the JavaScript `typeof` function to find the type of a value.  e.g.

	typeof 'hello'
	>> 'string'

	typeof [1, 2, 3]
	>> 'object'

### Variables ###
#### Declaring and Assigning ####
Variables have to be declared before they are used.  From ES6 onwards, use `let` and `const` to declare variables.  The `const` keyword should be used when the variable will not be reassigned to another value and `let` should be used when it can be reassigned.

For a constant you cannot reassign the variable

	const name = 'Alexa';
	name = 'Siri';
	<< TypeError: Assignment to constant variable.

Be aware that `const` does not make an  object reference immutable.  the contents of the object can still be re-assigned even if the variable reference to the object cannot, so this is legal:

	const name = { value: 'Alexa' }; // an object
	name.value = 'Siri'; // change the value
	<< 'Siri'

But this is not:

	// attempt to reassign to another object
	name = { value: 'Siri' }
	<< TypeError: Assignment to constant variable.

A `let` will allow reassignment:
	
	const name = { value: 'Alexa' }; // an object
	name.value = 'Siri'; // change the value
	<< 'Siri' 

You should try to use `const` to declare most variables. This helps to avoid any bugs caused by unexpected changes in assignment.

The `var` keyword is still in use, but should not be used unless you need to be backward compatible with ES5. Superficially it's use looks similar to `let` keyword.

	var number = 2;

Avoid `var` since it has the ability to pollute global scope unlike `const` and `let` which have block scope (or global scope if defined outside a block).

   