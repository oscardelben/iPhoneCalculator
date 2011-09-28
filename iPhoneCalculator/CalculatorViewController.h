

#import <UIKit/UIKit.h>

// We store the various buttons in a custom enumerator

typedef enum {
    kButtonMC, // 0
    kButtonMPlus, // 1
    kButtonMMinus, // 2
    kButtonMR, // etc
    
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
    kButton operation;
    BOOL deleteInput;
    double memory;
}

@property (nonatomic, retain) UILabel *resultLabel;
@property (nonatomic, retain) NSMutableString *resultText;

- (void)buttonPressed:(id)sender;

@end
