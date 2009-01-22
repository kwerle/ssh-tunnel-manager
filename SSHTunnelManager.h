/* SSHTunnelManager */

#import <Cocoa/Cocoa.h>

@interface SSHTunnelManager : NSObject
{
    IBOutlet id palette;
    IBOutlet id tunnelsTable;
    IBOutlet id shMenu;
    
    NSMutableArray *tunnels;
    NSWindowController *preferencesWindow;
}
- (IBAction)cancel:(id)sender;
- (IBAction)no:(id)sender;
- (IBAction)ok:(id)sender;
- (IBAction)openPreferences:(id)sender;
- (IBAction)yes:(id)sender;

- (IBAction)showHide:(id)sender;

- (int)numberOfTunnels;
@end
