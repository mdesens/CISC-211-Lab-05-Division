/*** asmFunc.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
@ Define the globals so that the C code can access them
/* define and initialize global variables that C can access */
/* create a string */
.global nameStr
.type nameStr,%gnu_unique_object
    
/*** STUDENTS: Change the next line to your name!  **/
nameStr: .asciz "Mark Desens"  

.align   /* realign so that next mem allocations are on word boundaries */
 
/* initialize a global variable that C can access to print the nameStr */
.global nameStrPtr
.type nameStrPtr,%gnu_unique_object
nameStrPtr: .word nameStr   /* Assign the mem loc of nameStr to nameStrPtr */
 
/* define and initialize global variables that C can access */

.global dividend,divisor,quotient,mod,we_have_a_problem
.type dividend,%gnu_unique_object
.type divisor,%gnu_unique_object
.type quotient,%gnu_unique_object
.type mod,%gnu_unique_object
.type we_have_a_problem,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmFunc gets called, you must set
 * them to 0 at the start of your code!
 */
dividend:          .word     0  
divisor:           .word     0  
quotient:          .word     0  
mod:               .word     0 
we_have_a_problem: .word     0

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

    
/********************************************************************
function name: asmFunc
function description:
     output = asmFunc ()
     
where:
     output: 
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmFunc
.type asmFunc,%function
asmFunc:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
.if 0
    /* profs test code. */
    mov r0,r0
.endif
    
    /** note to profs: asmFunc.s solution is in Canvas at:
     *    Canvas Files->
     *        Lab Files and Coding Examples->
     *            Lab 5 Division
     * Use it to test the C test code */
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/

    /* START - INITIALIZE VARIABLES TO 0 */
    
    // Used to initialize variales to 0
    LDR r4, =0
    
    // Load the address where the value is stored to a register.
    LDR r5, =dividend 
    // Set value to unsigned input value (r0 per instructions)
    STR r0, [r5] 
    
    // Load the address where the value is stored to a register.
    LDR r6, =divisor 
    // Set value to unsigned input value (r1 per instructions)
    STR r1, [r6] 
    
    // Load the address where the value is stored to a register.
    LDR r7, =quotient 
    // Set value to 0
    STR r4, [r7] 
            
    // Load the address where the value is stored to a register.
    LDR r8, =mod 
    // Set value to 0
    STR r4, [r8] 
            
    // Load the address where the value is stored to a register.
    LDR r9, =we_have_a_problem 
    // Set value to 0
    STR r4, [r9] 
    
    /* END - INITIALIZE VARIABLES TO 0 */
    
    /* START - MAIN LOGIC */
    
    // Validate that dividend and divisor are not 0
    
    // Compare dividend to 0
    LDR r5, [r5]
    CMP r5, 0
    // If dividend is equal to zero then branch to error_found
    BEQ error_found

    // Compare divisor to 0
    LDR r6, [r6]
    CMP r6, 0
    // If dividend is equal to zero then branch to error_found
    BEQ error_found	
    
    // Perform division-by-subtraction
    division_by_subtraction:
	// branch to final_code if the dividend is less than the divisor, otherwise continue with calculations
	CMP r5, r6
	BLO final_code
	// subtract the divisor from the dividend
	SUBS r5, r5, r6
	// add 1 to the quotient since we were able to subtract the divisor from the dividend
	LDR r10, [r7]
	ADDS r10, r10, 1
	STR r10, [r7]
	// loop - branch back to start of division_by_subtraction
	B division_by_subtraction
	
    
    /* END - MAIN LOGIC */
    
/* START - BRANCHES */

// runs last for non-happy path
error_found:
    // we_have_a_problem should be set to 1 (true) since an error was encountered
    LDR r10, =1
    STR r10, [r9]
    // Per instructions, set r0 to the address of the quotient
    LDR r0, =quotient
    B done
    
// runs last for happy path    
final_code:
    // set mod
    STR r5, [r8]
    // we_have_a_problem should be set to 0 (false) since there were no errors
    LDR r10, =0
    STR r10, [r9]
    // Per instructions, set r0 to the address of the quotient
    LDR r0, =quotient
    B done


/* END - BRANCHES */
    
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    mov r0,r0 /* these are do-nothing lines to deal with IDE mem display bug */
    mov r0,r0 /* this is a do-nothing line to deal with IDE mem display bug */

screen_shot:    pop {r4-r11,LR}

    mov pc, lr	 /* asmFunc return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




