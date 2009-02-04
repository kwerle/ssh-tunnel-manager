#import "SSHTunnelApp.h"
#import "SSHTunnel.h"
#import "passWindowController.h"

@implementation SSHTunnelApp

- (NSMutableArray*)tunnels
{
    return [[ SSHTunnel tunnelsFromArray: [ [ NSUserDefaults standardUserDefaults ] objectForKey: @"tunnels" ]] mutableCopy ];
}

- (id)authenticate:(NSScriptCommand *)command {
    NSDictionary *args = [command evaluatedArguments];
    NSString *givenQuery = [ args objectForKey:@"query"];
    NSString *tunnelName = [ args objectForKey:@"tunnelName"];
    NSString *fifo = [ args objectForKey:@"fifo"];
    //NSString *result = @"";
    SSHTunnel *tunnel;
    NSEnumerator *e;
    passWindowController *wc;
	NSWindow *window;
	//    int RC;
    
    e = [ tunnels objectEnumerator ];
    while (tunnel = [ e nextObject ])
    {
		if ([[ tunnel valueForKey: @"connName" ] isEqual: tunnelName ])
			break;
    }
	
    if ([ givenQuery  rangeOfString: @" (yes/no)? " ].location != NSNotFound )
    {
		wc = [[ NSWindowController alloc ] initWithWindowNibName: @"ynQuery" ];
		window = [wc window];
		[[ wc window ] center ];
		[[ wc window ] setValue: fifo forKey: @"fifo" ];
		[[ wc window ] setValue: tunnel forKey: @"tunnel" ];
		[[ wc window ] setTitle: [ tunnel valueForKey: @"connName" ]];
		[(passWindowController*)[ wc window ] setACaption: givenQuery ];
		[[ wc window ] makeKeyAndOrderFront: self ];
    }
    else
    {
		wc = [[ passWindowController alloc ] initWithWindowNibName: @"passQuery"];
		window = [wc window];
		[wc setFifo: fifo];
		[wc setTunnel: tunnel];
		//[window setTitle: [ tunnel connName]];
		[wc setACaption: givenQuery ];
		[window makeKeyAndOrderFront: self ];
    }
    
	return @"OK";
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    return NSTerminateNow;
}

-(id)handleQuitScriptCommand:(NSScriptCommand *)command {
    [ NSApp terminate: self ];
	return self;
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
