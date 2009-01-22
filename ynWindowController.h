/* ynWindowController */

#import <Cocoa/Cocoa.h>
#import "SSHTunnel.h"

@interface ynWindowController : NSWindow
{
    IBOutlet id caption;
    
    NSString *fifo;
    SSHTunnel *tunnel;
}
- (IBAction)no:(id)sender;
- (IBAction)yes:(id)sender;
- (void)setACaption:(NSString*)theCaption;
@end
