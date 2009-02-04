#import "passWindowController.h"

@implementation passWindowController

@synthesize fifo;
@synthesize tunnel;

- (IBAction)pwcCancel:(id)sender
{
    [ tunnel stopTunnel ];
    [ [sender window] close ];
}

- (void) setFifo: (NSString *) newFIFO {
	[fifo autorelease];
	fifo = [newFIFO retain];
}

- (IBAction)pwcOk:(id)sender
{
    NSFileHandle *fh = [ NSFileHandle fileHandleForWritingAtPath: fifo ];
    [ fh writeData: [[ password stringValue ] dataUsingEncoding: NSASCIIStringEncoding ]];
    [ fh closeFile ];
    [ [sender window] close ];
}

- (void)setACaption:(NSString*)theCaption;
{
    [ caption setStringValue: theCaption ];
}

@end