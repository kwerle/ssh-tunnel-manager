#import "SSHTunnelManager.h"
#import "SSHTunnel.h"
#import "SSHTunnelApp.h"
#import "TunnelsTableView.h"
#import "passWindowController.h"

#define B_START NSLocalizedString(@"B_START",@"")
#define B_STOP NSLocalizedString(@"B_STOP",@"")

#define SHMENU_SHOW NSLocalizedString(@"SHMENU_SHOW",@"")
#define SHMENU_HIDE NSLocalizedString(@"SHMENU_HIDE",@"")

@implementation SSHTunnelManager
- (void)awakeFromNib
{
    SInt32 vers; 
    Gestalt(gestaltSystemVersion,&vers); 
    [[ NSUserDefaults standardUserDefaults ] registerDefaults:
        [ NSDictionary dictionaryWithObjectsAndKeys:
	    [ NSNumber numberWithBool: YES ], @"autoOpen",
	    nil ]];
    
    //[[ NSScriptExecutionContext sharedScriptExecutionContext] setTopLevelObject: self ];

    // Image cell
    NSImageCell *myCell = [[ NSImageCell alloc] init ];
    [[ tunnelsTable tableColumnWithIdentifier: @"icon"] setDataCell: myCell ];
    [ myCell release ];
    [ tunnelsTable setSelectionActive: NO ];

    // Button cell
    NSButtonCell *buttonCell = [[ NSButtonCell alloc ] init ];
    [ buttonCell setBezelStyle: NSShadowlessSquareBezelStyle ];
    [ buttonCell setButtonType: NSMomentaryPushInButton ];
    [ buttonCell setBordered: NO ];
    [ buttonCell setShowsStateBy: NSNoCellMask ];
    [ buttonCell setHighlightsBy: NSNoCellMask ];
    [ buttonCell setTitle: @"" ];
    [ buttonCell setImage: [ NSImage imageNamed: @"start_n" ]];
    [ buttonCell setAlternateImage: [ NSImage imageNamed: @"start_p" ]];
    
    [[ tunnelsTable tableColumnWithIdentifier:@"button"] setDataCell: buttonCell ];
    [ buttonCell release ];
    
    [ tunnelsTable setDoubleAction: @selector(doubleAction:) ];
    [ tunnelsTable setTarget: self ];
    // Read tunnels informations
    tunnels = [[ (SSHTunnelApp*)NSApp tunnels ] retain ];
    
    [[ NSNotificationCenter defaultCenter] addObserver: self 
					      selector:@selector(tunnelLaunchedNotification:) 
						  name: @"STMStatusChanged"
						object: nil ];
    [[ NSNotificationCenter defaultCenter] addObserver: self 
					      selector:@selector(prefChanged:) 
						  name: @"STMPrefChanged"
						object: nil ];
    [ palette setShowsResizeIndicator: NO ];
    [ palette setFrameUsingName: @"tunnelsWindow" ];
    if ([[[ NSUserDefaults standardUserDefaults ] objectForKey: @"openPalette" ] boolValue ] || ! [[ NSUserDefaults standardUserDefaults ] objectForKey: @"openPalette" ])
    {
	[ palette makeKeyAndOrderFront: self ];
	[ shMenu setTitle: SHMENU_HIDE ];
    }
    else
    {
	[ shMenu setTitle: SHMENU_SHOW ];
    }
}

#pragma mark -
#pragma mark TableView related code
- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [ self numberOfTunnels ];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
    if (aTableView == tunnelsTable )
    {
	if ([[aTableColumn identifier ] isEqual: @"icon" ])
	    return [[ tunnels objectAtIndex: rowIndex ] icon ];
	else if ([[aTableColumn identifier ] isEqual: @"text" ])
	{
	    SSHTunnel *tunnel = [ tunnels objectAtIndex: rowIndex ];
	    NSString *name = [ tunnel  valueForKey: @"connName" ];
	    
	    NSDictionary *title = [ NSDictionary dictionaryWithObjectsAndKeys:
		[ NSFont systemFontOfSize: [ NSFont systemFontSize ]], NSFontAttributeName,[ NSColor blackColor ],
		@"NSForegroundColorAttributeName", nil];
	    
	    NSDictionary *state;
	    if (rowIndex == [ aTableView selectedRow ])
	    {
		state = [ NSDictionary dictionaryWithObjectsAndKeys:
		[ NSFont systemFontOfSize: [ NSFont smallSystemFontSize ]], NSFontAttributeName,[ NSColor colorWithCalibratedRed: 0.5
															 green: 0.5
															  blue: 0.5
															 alpha: 1 ],
		NSForegroundColorAttributeName, nil];
	    }
	    else
	    {
		state = [ NSDictionary dictionaryWithObjectsAndKeys:
		    [ NSFont systemFontOfSize: [ NSFont smallSystemFontSize ]], NSFontAttributeName,[ NSColor colorWithCalibratedRed: 0.5
															       green: 0.5
																blue: 0.5
															       alpha: 1 ],
		    NSForegroundColorAttributeName, nil];
	    }
	    NSMutableAttributedString *att = [[ NSMutableAttributedString alloc ] initWithString: name
									 attributes: title ];
	    [ att appendAttributedString:[[[ NSAttributedString alloc ] initWithString: [ NSString stringWithFormat: @"\n%@",[[ tunnels objectAtIndex: rowIndex ] valueForKey: @"status"]] attributes: state ] autorelease ]];

	    return [ att autorelease ];
	}
	else if ([[ aTableColumn identifier ] isEqual: @"button" ])
	{
	    if ([[ tunnels objectAtIndex: rowIndex ] isRunning ])
	    {
		//[[aTableColumn dataCellForRow: rowIndex ] setTitle: B_STOP ];
		[[aTableColumn dataCellForRow: rowIndex ] setImage: [ NSImage imageNamed: @"stop_n"]];   
		[[aTableColumn dataCellForRow: rowIndex ] setAlternateImage: [ NSImage imageNamed: @"stop_p"]];   
	    }
	    else
	    {
		//[[aTableColumn dataCellForRow: rowIndex ] setTitle: B_START ];  
		[[aTableColumn dataCellForRow: rowIndex ] setImage: [ NSImage imageNamed: @"start_n"]];   
		[[aTableColumn dataCellForRow: rowIndex ] setAlternateImage: [ NSImage imageNamed: @"start_p"]];   
	    }
	}
    }
    return nil;
}
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
    if ([[ aTableColumn identifier ] isEqual: @"button" ] && [ anObject boolValue ])
	[[ tunnels objectAtIndex: rowIndex ] toggleTunnel ];
    [ tunnelsTable reloadData ];
}
- (void)doubleAction:(id)sender
{
    [[ tunnels objectAtIndex: [ tunnelsTable selectedRow ]] startTunnel ];
}
- (int)numberOfTunnels
{
    return [ tunnels count ];
}
- (void)tunnelLaunchedNotification:(NSNotification*)aNotification
{
    [ tunnelsTable reloadData ];
    [[ tunnelsTable window ] display ];
}

-(IBAction)openPreferences:(id)sender
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
    if (! preferencesWindow)
    {
	preferencesWindow = [[ NSWindowController alloc ] initWithWindowNibName: @"Preferences" ];
    }
    [[ preferencesWindow window ] center ];
    [[ preferencesWindow window ] makeKeyAndOrderFront: self ];
    [ NSApp runModalForWindow: [ preferencesWindow window ]];
    [ preferencesWindow release ];
    preferencesWindow = nil;
    [ pool release ];
}
-(void)prefChanged:(NSNotification*)aNotification
{
    [ tunnelsTable reloadData ];
    [[ tunnelsTable window ] display ];
}

- (IBAction)ok:(id)sender;
{
    [ NSApp stopModalWithCode: 2 ];
}
- (IBAction)cancel:(id)sender;
{
    [ NSApp stopModalWithCode: 1 ];
}
- (IBAction)yes:(id)sender;
{
    [ NSApp stopModalWithCode: 2 ];
}
- (IBAction)no:(id)sender;
{
    [ NSApp stopModalWithCode: 1 ];
}
#pragma mark -
#pragma mark Misc.

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    NSEnumerator *e;
    SSHTunnel *t;
    
    e = [ tunnels objectEnumerator ];
    while (t = [e nextObject ])
	[ t stopTunnel ];
    
    [ palette saveFrameUsingName: @"tunnelsWindow" ];
    [[ NSUserDefaults standardUserDefaults ] setObject: [ NSNumber numberWithBool: [ palette isVisible ]] forKey: @"openPalette" ];
}

- (IBAction)showHide:(id)sender;
{
    if (! [ palette isVisible ])
    {
	[ palette makeKeyAndOrderFront: self ];
	[ shMenu setTitle: SHMENU_HIDE ];
    }
    else
    {
	[ palette close ];
	[ shMenu setTitle: SHMENU_SHOW ];
    }
}
@end
