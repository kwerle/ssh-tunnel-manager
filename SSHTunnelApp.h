/* SSHTunnelApp */

#import <Cocoa/Cocoa.h>

@interface SSHTunnelApp : NSApplication
{
    NSMutableArray *tunnels;
}
- (NSMutableArray*)tunnels;
//- (id)handleQuitScriptCommand:(NSScriptCommand *)command ;
@end
