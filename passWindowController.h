/* passWindowController */

#import <Cocoa/Cocoa.h>
#import "SSHTunnel.h"
@interface passWindowController : NSWindowController
{
    IBOutlet id caption;
    IBOutlet id password;
    
    NSString *fifo;
    SSHTunnel *tunnel;
}

@property (copy) NSString *fifo;
@property (assign) SSHTunnel *tunnel;

- (IBAction)pwcCancel:(id)sender;
- (IBAction)pwcOk:(id)sender;

- (void)setACaption:(NSString*)theCaption;
@end
