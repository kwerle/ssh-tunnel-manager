/* passWindowController */

#import <Cocoa/Cocoa.h>
#import "SSHTunnel.h"
@interface passWindowController : NSWindow
{
    IBOutlet id caption;
    IBOutlet id password;
    
    NSString *fifo;
    SSHTunnel *tunnel;
}
- (IBAction)pwcCancel:(id)sender;
- (IBAction)pwcOk:(id)sender;

- (void)setACaption:(NSString*)theCaption;
@end
