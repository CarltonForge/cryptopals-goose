
 

// hex to bytes. first check the length: make sure the string has a
// even number of characters. if it is odd pad the very front with a 0 to make it even
// split into pairs: Slice the sting into chunks of two characters from left to right.
// eg 48656C6C6F becomes 48, 65, 6C, 6C, 6F
// apply the formula to each pair: run the (first digit x 16) + second digit
// math on every pair to get your sequence of bytes value
//
// 
// Here is how 48656C6C6F converts into a sequence of five bytes:

//Hex Pair Math Calculation Byte Value (Decimal)
// 48	(4 × 16) + 8	72
// 65	(6 × 16) + 5	101
// 6C	(6 × 16) + 12	108
// 6C	(6 × 16) + 12	108
// 6F	(6 × 16) + 15	111

// The final result is the byte array [72, 101, 108, 108, 111]
// (which translates to the text "Hello" in ASCII).


fn main() {


    let theString = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d";



    let firstChar = theString[0..1];
    let secondChar = theString[1..2];

    let firstByte = theString[0]; // bytess are viewed as ASCII numerical representation eg 4 = 52 to goose.
    let secondByte = theString[1];

        
    fn hexProcess(firstByte: i64, secondByte: i64) {

        

        let firstByte = firstByte ;
        let secondByte = secondByte ; // literal 0 is actually 48 ascii 
         
        return firstByte  * 16 + secondByte ;
    }

    fn hexDigit(character:u8){
        return match character{
            
        48..58 => character - 48,
        97..103 => character - 87,
        65..71 => character - 55,
        _ => -1,    
        };
        
    }
    
        
 
    var cleanHexNumbers: i64 [>..] = [];

    var i = 0;
    while i <  theString.len {
        var firstChar = theString[i];
        var secondChar = theString[i + 1];

        var firstDigit = hexDigit(firstChar);
        var secondDigit = hexDigit(secondChar);
        
            
        var result = hexProcess(firstDigit, secondDigit);
        
        
        cleanHexNumbers.push(result);
        i += 2;
        
    
        
        
    }
    /* -- for every pair in our cleanHexNumbers is 1 byte which is 8 Bits
        because each hex digit is a 4 bit nibble (2 x 4 = b bits).

        Byte 1       Byte 2       Byte 3
        01001001     00100111     01101101

         join them ->  010010010010011101101101

        now split that continous stream into groups of 6 for base 64.
        010010 | 010010 | 011101 | 101101

        orignal bytes = 8 + 8 + 8 .
        base64 groups = 6 + 6 + 6 + 6 .

        24 bits in, 24 bits out. Only the boundaries change.

        so we read binary from right to left but shift from left to right.

        Bit:       0  1  0  0  1  0  0  1
        Position:  7  6  5  4  3  2  1  0
        Value:   128 64 32 16  8  4  2  1

        so 73
                   0  1  0  0  1  0  0  1
        would be:

        then we add a mask to keep the significant bits.
        we only need 6 so we use 00111111
        which is 0x3F which is base 16 and 0x prefix
        tells the compiler that the number is written
        in base 16 eg. 0123456789ABCDEF
        where A = 10, B = 11 ...F = 15.
        so 3F = (3 x 16) + 15 = 63
        therefore 0x3f = 63 decimal. which makes it a good mask.
        because converted into binary:
        Decimal:      63
        Hexadecimal:  0x3F
        Binary:       00111111

        because base 64 uses 6 bits we have to shift all bits to the right
        by 2 to keep 6 bits before applying the mask.
        our number is 73 so the mask will remove everything which gives us 9
        
           01001001
    AND    00111111
           --------
           00001001     Hex mask	Decimal	Binary	Keeps
                            0x01	1	00000001	1 bit
                            0x03	3	00000011	2 bits
                            0x0F	15	00001111	4 bits
                            0x3F	63	00111111	6 bits
                            0xFF	255	11111111	8 bits        

    */

         var i = 0;

        var base64Output: u8  [>..] = [];
        while i + 2 < cleanHexNumbers.len{
            let a = cleanHexNumbers[i];
            let b = cleanHexNumbers[i+1];
            let c = cleanHexNumbers[i+2];
        
            let group1:i64 = a >> 2 & 0x3F;
            let group2:i64 = (a & 0x03) << 4 | (b >> 4);
            let group3:i64 = (b & 0x0F) << 2 | (c >> 6);
            let group4:i64 = c & 0x3F;


        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        let char1 = alphabet[group1];
        let char2 = alphabet[group2];
        let char3 = alphabet[group3];
        let char4 = alphabet[group4];


        base64Output.push(char1);
        base64Output.push(char2);
        base64Output.push(char3);
        base64Output.push(char4);
        i+=3;
    }
    
    if base64Output == "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"{
        print("yes");
    }

    
    print("the clean hex: \n", cleanHexNumbers);
    print(": \n" , base64Output );
    

}
