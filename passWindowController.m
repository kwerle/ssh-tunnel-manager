#import "passWindowController.h"

@implementation passWindowController

- (IBAction)pwcCancel:(id)sender
{
    [ tunnel stopTunnel ];
    [ self close ];
}

- (IBAction)pwcOk:(id)sender
{
    NSFileHandle *fh = [ NSFileHandle fileHandleForWritingAtPath: fifo ];
    [ fh writeData: [[ password stringValue ] dataUsingEncoding: NSASCIIStringEncoding ]];
    [ fh closeFile ];
    [ self close ];
}

- (void)setACaption:(NSString*)theCaption;
{
    [ caption setStringValue: theCaption ];
}

@end