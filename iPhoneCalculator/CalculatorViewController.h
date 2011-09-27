

#import <UIKit/UIKit.h>

typedef enum {
    kButtonMC,
    kButtonMPlus,
    kButtonMMinus,
    kButtonMR,
    
    kButtonAC,
    kButtonChangeSign,
    kButtonDivide,
    kButtonMultiply,
    
    kButtonSeven,
    kButtonEight,
    kButtonNine,
    kButtonSubtract,
    
    kButtonFour,
    kButtonFive,
    kButtonSix,
    kButtonAdd,
    
    kButtonOne,
    kButtonTwo,
    kButtonThree,
    
    kButtonZero,
    kButtonDot,
    kButtonEqual
} kButton;

@interface CalculatorViewController : UIViewController
{
    NSNumber *leftOperator;
    kButton operation; // We're going to use kButtons to store the operation to simplify things
    BOOL deleteInput;
    double memory;
}

@property (nonatomic, retain) UILabel *resultLabel;
@property (nonatomic, retain) NSMutableString *resultText;

- (void)buttonPressed:(id)sender;

@end
