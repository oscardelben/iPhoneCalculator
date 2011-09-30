
#import "CalculatorViewController.h"

@implementation CalculatorViewController

@synthesize resultLabel;
@synthesize resultText;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
    
    resultLabel = nil;
    resultText = nil;
    leftOperator = nil;
}

#pragma mark - View lifecycle

// row and column are 0 indexed. We use this code to programmatically create a button

- (void)addButtonWithTitle:(NSString *)aTitle tag:(int)tag row:(int)row column:(int)column width:(int)width height:(int)height
{
    UIButton *button;
    float x, y;
    
    x = BUTTON_H_PADDING + (BUTTON_WIDTH + BUTTON_H_PADDING) * column;
    y = TEXTAREA_HEIGHT + BUTTON_V_PADDING + (BUTTON_HEIGHT + BUTTON_V_PADDING) * row;
    
    float buttonWidth = BUTTON_WIDTH;
    float buttonHeight = BUTTON_HEIGHT;
    
    if (width > 1)
        buttonWidth = (BUTTON_WIDTH + BUTTON_H_PADDING) * width - BUTTON_H_PADDING;
    
    if (height > 1)
        buttonHeight = (BUTTON_HEIGHT + BUTTON_V_PADDING) * height - BUTTON_V_PADDING;
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
    
    [button setTitle:aTitle forState:UIControlStateNormal];
    
    button.tag = tag;
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // the initial result
    self.resultText = [NSMutableString stringWithString:@"0"];
    
    // Add a nice background color to our view
    self.view.backgroundColor = [UIColor lightGrayColor];

    // We add a label to the top that will display the results
    self.resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, TEXTAREA_WIDTH, TEXTAREA_HEIGHT)];

    resultLabel.text = resultText; // default label
    resultLabel.textAlignment = UITextAlignmentRight;
    resultLabel.font = [UIFont systemFontOfSize:24];
    
    // Add it to the view
    [self.view addSubview:resultLabel];
    
    // initialize memory to 0
    memory = 0;
    
    // Add buttons
    [self addButtonWithTitle:@"mc"      tag:kButtonMC           row:0 column:0 width:1 height:1];
    [self addButtonWithTitle:@"m+"      tag:kButtonMPlus        row:0 column:1 width:1 height:1];
    [self addButtonWithTitle:@"m-"      tag:kButtonMMinus       row:0 column:2 width:1 height:1];
    [self addButtonWithTitle:@"mr"      tag:kButtonMR           row:0 column:3 width:1 height:1];
    
    [self addButtonWithTitle:@"AC"      tag:kButtonAC           row:1 column:0 width:1 height:1];
    [self addButtonWithTitle:@"\u00B1"  tag:kButtonChangeSign   row:1 column:1 width:1 height:1];
    [self addButtonWithTitle:@"\u00F7"  tag:kButtonDivide       row:1 column:2 width:1 height:1];
    [self addButtonWithTitle:@"\u00D7"  tag:kButtonMultiply     row:1 column:3 width:1 height:1];
    
    [self addButtonWithTitle:@"7"       tag:kButtonSeven        row:2 column:0 width:1 height:1];
    [self addButtonWithTitle:@"8"       tag:kButtonEight        row:2 column:1 width:1 height:1];
    [self addButtonWithTitle:@"9"       tag:kButtonNine         row:2 column:2 width:1 height:1];
    [self addButtonWithTitle:@"\u2212"  tag:kButtonSubtract     row:2 column:3 width:1 height:1];
    
    [self addButtonWithTitle:@"4"       tag:kButtonFour         row:3 column:0 width:1 height:1];
    [self addButtonWithTitle:@"5"       tag:kButtonFive         row:3 column:1 width:1 height:1];
    [self addButtonWithTitle:@"6"       tag:kButtonSix          row:3 column:2 width:1 height:1];
    [self addButtonWithTitle:@"+"       tag:kButtonAdd          row:3 column:3 width:1 height:1];
    
    [self addButtonWithTitle:@"1"       tag:kButtonOne          row:4 column:0 width:1 height:1];
    [self addButtonWithTitle:@"2"       tag:kButtonTwo          row:4 column:1 width:1 height:1];
    [self addButtonWithTitle:@"3"       tag:kButtonThree        row:4 column:2 width:1 height:1];
    [self addButtonWithTitle:@"="       tag:kButtonEqual        row:4 column:3 width:1 height:2];
    
    [self addButtonWithTitle:@"0"       tag:kButtonZero         row:5 column:0 width:2 height:1];
    [self addButtonWithTitle:@"."       tag:kButtonDot          row:5 column:2 width:1 height:1];
}

#pragma mark utilities

// If you pass 0, it will use the previously saved operation
- (void)doOperation:(int)theOperation
{
    double result;
    
    if (theOperation == 0)
        theOperation = operation;
    
    switch (theOperation) {
        case kButtonMultiply:
            result = [leftOperator doubleValue] * [resultText doubleValue];
            break;
        case kButtonDivide:
            result = [leftOperator doubleValue] / [resultText doubleValue];
            break;
        case kButtonAdd:
            result = [leftOperator doubleValue] + [resultText doubleValue];
            break;
        case kButtonSubtract:
            result = [leftOperator doubleValue] - [resultText doubleValue];
            break;
        case kButtonChangeSign:
            result = [leftOperator doubleValue] * -1;
            break;
    }
    
    // reset the leftOperator
    leftOperator = nil;
    
    self.resultText = [NSMutableString stringWithFormat:@"%f", result];
}

- (void)performOperation:(int)theOperation
{
    // if we have a right operator already, compute the existing value
    if (leftOperator) {
        [self doOperation:theOperation];
    } else {
        // save the existing operation for later
        operation = theOperation;
    }
    
    // assign the left operation for later use
    leftOperator = [NSNumber numberWithDouble:[resultText doubleValue]];
}

- (NSMutableString *)readableNumberFromString:(NSString *)aString
{
    // given 12.30000 we remove the trailing zeros
    NSMutableString *result = [NSMutableString stringWithString:aString];
    
    // check if it contains a . character.
    if ([result rangeOfString:@"."].location != NSNotFound) {
        
        // start from the end, and remove any 0 or . you find until you find a number greater than 0
        for (int i = [result length] - 1; i >= 0; i--) {
            // get the char
            unichar currentChar = [result characterAtIndex:i];
            
            if (currentChar == '0') {
                // remove it from the string
                [result replaceCharactersInRange:NSMakeRange(i, 1) withString:@""];
            } else if (currentChar == '.') {
                // remove it from the string
                [result replaceCharactersInRange:NSMakeRange(i, 1) withString:@""];
                break;
            }
            else {
                break;
            }
        }
    }
    
    // assign default value if needed
    if ([result isEqualToString:@""]) {
        [result appendString:@"0"];
    }
    
    // remove the initial 0 if present
    if ([result length] > 1 && [result characterAtIndex:0] == '0') {
        [result replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    
    return result;
}

#pragma mark actions

// This is a macro function that I use below to DRY up the code
#define ADD_DIGIT(x) [self.resultText appendFormat:@"%d", x]

- (void)buttonPressed:(id)sender
{
    // We sometimes need to delete the current text, but we never have to do so for the change sign button
    if (deleteInput && [sender tag] != kButtonChangeSign) {
        [resultText setString:@""];
    }
    deleteInput = NO;
    
    // See which button the user pressed
    switch ([sender tag]) {
        case kButtonMC:
            // reset memory
            memory = 0;
            break;
        case kButtonMPlus:
            // add number to memory
            memory += [resultText doubleValue];
            deleteInput = YES;
            break;
        case kButtonMMinus:
            // subract number from memory
            memory -= [resultText doubleValue];
            deleteInput = YES;
            break;
        case kButtonMR:
            // recall memory
            self.resultText = [NSMutableString stringWithFormat:@"%f", memory];
            deleteInput = YES;
            break;
        case kButtonAC:
            // reset screen
            self.resultText = [NSMutableString stringWithString:@"0"];
            leftOperator = nil;
            break;
        case kButtonChangeSign:
            // force the left operator since we only have one in this case
            leftOperator = [NSNumber numberWithDouble:[resultText doubleValue]];

            [self performOperation:kButtonChangeSign];
            deleteInput = YES;
            break;
        case kButtonDivide:
            [self performOperation:kButtonDivide];
            deleteInput = YES;
            break;
        case kButtonMultiply:
            [self performOperation:kButtonMultiply];
            deleteInput = YES;
            break;
        case kButtonSeven:
            ADD_DIGIT(7);
            break;
        case kButtonEight:
            ADD_DIGIT(8);
            break;
        case kButtonNine:
            ADD_DIGIT(9);
            break;
        case kButtonSubtract:
            [self performOperation:kButtonSubtract];
            deleteInput = YES;
            break;
        case kButtonFour:
            ADD_DIGIT(4);
            break;
        case kButtonFive:
            ADD_DIGIT(5);
            break;
        case kButtonSix:
            ADD_DIGIT(6);
            break;
        case kButtonAdd:
            [self performOperation:kButtonAdd];
            deleteInput = YES;
            break;
        case kButtonOne:
            ADD_DIGIT(1);
            break;
        case kButtonTwo:
            ADD_DIGIT(2);
            break;
        case kButtonThree:
            ADD_DIGIT(3);
            break;
        case kButtonZero:
            ADD_DIGIT(0);
            break;
        case kButtonDot:
            // handle later
            break;
        case kButtonEqual:
            [self doOperation:0];
            deleteInput = YES;
            break;
    }
    
    // prettify result
    self.resultText = [self readableNumberFromString:resultText];
    
    // check if we need to add a dot, like Apple's calculator does.
    if ([sender tag] == kButtonDot) {
        [resultText appendString:@"."];
    }
    
    // finally show the text to the user
    resultLabel.text = resultText;
}

@end
