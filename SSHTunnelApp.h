/* SSHTunnelApp */

#import <Cocoa/Cocoa.h>

/* This class implements the AppleScript event requesting authentication */
@interface SSHTunnelApp : NSApplication
{
    NSMutableArray *tunnels;
}
- (NSMutableArray*)tunnels;
- (id)authenticate:(NSScriptCommand *)command;
@end
