#import "ynWindowController.h"

@implementation ynWindowController

- (IBAction)no:(id)sender
{
    NSFileHandle *fh = [ NSFileHandle fileHandleForWritingAtPath: fifo ];
    [ fh writeData: [[ NSString stringWithString: @"no" ] dataUsingEncoding: NSASCIIStringEncoding ]];
    [ fh closeFile ];
    [ self close ];
}

- (IBAction)yes:(id)sender
{
    NSFileHandle *fh = [ NSFileHandle fileHandleForWritingAtPath: fifo ];
    [ fh writeData: [[ NSString stringWithString: @"yes" ] dataUsingEncoding: NSASCIIStringEncoding ]];
    [ fh closeFile ];
    [ self close ];    
}

- (void)setACaption:(NSString*)theCaption;
{
    [ caption setStringValue: theCaption ];
}


@end
