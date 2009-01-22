#import "SSHTunnelApp.h"
#import "SSHTunnel.h"
#import "passWindowController.h"

@implementation SSHTunnelApp
/*
 - (void)awakeFromNib
{
    [ self setDelegate: self ];
}
*/
- (NSMutableArray*)tunnels
{
    if (! tunnels)
    {
	NSUserDefaults *ud = [ NSUserDefaults standardUserDefaults ];
	tunnels = [[ SSHTunnel tunnelsFromArray: [ ud objectForKey: @"tunnels" ]] mutableCopy ];
    }
    return tunnels;
}

- (id)authenticate:(NSScriptCommand *)command {
    NSDictionary *args = [command evaluatedArguments];
    NSString *givenQuery = [ args objectForKey:@"query"];
    NSString *tunnelName = [ args objectForKey:@"tunnelName"];
    NSString *fifo = [ args objectForKey:@"fifo"];
    NSString *result = @"";
    SSHTunnel *tunnel;
    NSEnumerator *e;
    NSWindowController *wc;
//    int RC;
    
    e = [ tunnels objectEnumerator ];
    while (tunnel = [ e nextObject ])
    {
	if ([[ tunnel valueForKey: @"connName" ] isEqual: tunnelName ])
	    break;
    }
    if ([ givenQuery  rangeOfString: @" (yes/no)? " ].location != NSNotFound )
    {
	/*
	 wc = [[ NSWindowController alloc ] initWithWindowNibName: @"ynQuery" ];
	 [ wc window ];
	 //[ wc setCaption: givenQuery ];
	 RC=[ NSApp runModalForWindow: ynAlertPanel ];
	 [ ynAlertPanel orderOut: self ];
	 
	 if (RC==1)
	 result = @"no";
	 else if (RC==2)
	 result = @"yes";
	 */
	wc = [[ NSWindowController alloc ] initWithWindowNibName: @"ynQuery" ];
	[[ wc window ] center ];
	[[ wc window ] setValue: fifo forKey: @"fifo" ];
	[[ wc window ] setValue: tunnel forKey: @"tunnel" ];
	[[ wc window ] setTitle: [ tunnel valueForKey: @"connName" ]];
	[(passWindowController*)[ wc window ] setACaption: givenQuery ];
	[[ wc window ] makeKeyAndOrderFront: self ];
	return @"OK";
	
    }
    else
    {
	wc = [[ NSWindowController alloc ] initWithWindowNibName: @"passQuery" ];
	[[ wc window ] center ];
	[[ wc window ] setValue: fifo forKey: @"fifo" ];
	[[ wc window ] setValue: tunnel forKey: @"tunnel" ];
	[[ wc window ] setTitle: [ tunnel valueForKey: @"connName" ]];
	[(passWindowController*)[ wc window ] setACaption: givenQuery ];
	[[ wc window ] makeKeyAndOrderFront: self ];
	return @"OK";
	/*
	 [ alertText setStringValue: givenQuery ];
	 RC=[ NSApp runModalForWindow: alertPanel ];
	 [ alertPanel orderOut: self ];
	 if (RC==2)
	 result = [ passwordField stringValue ];
	 else
	 {
	     [ tunnel stopTunnel ] ;
	     return nil;
	 }
	 [ passwordField setStringValue: @""];
	 */
    }
    
    return result;
}
/*- (id)handleQuitScriptCommand:(NSScriptCommand *)command {
    NSLog(@"test");
    return YES;
    [ NSApp terminate: self ];
}
*/
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    return NSTerminateNow;
}
-(id)handleQuitScriptCommand:(NSScriptCommand *)command {
    [ NSApp terminate: self ];
}

- (void)orderFrontStandardAboutPanel:(id)sender
{
    [ self orderFrontStandardAboutPanelWithOptions: [ NSDictionary dictionaryWithObjectsAndKeys: 
	[ NSString stringWithFormat: @"%X",
	[[[ NSBundle mainBundle ] objectForInfoDictionaryKey: @"CFBundleVersion" ] intValue]
	    ]
	,@"Version", nil ]];
}
@end
