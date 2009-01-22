#import "PreferencesController.h"
#import "SSHTunnel.h"
#import "SSHTunnelApp.h"
#import "TynsoeClasses.h"
@implementation PreferencesController

- (void)awakeFromNib
{
     tunnels = [[ (SSHTunnelApp*)NSApp tunnels] retain ];
    [ (TLinkTextField*)urlTextField setURL: @"http://projects.tynsoe.org/stm" ];
    mainFrameRect = [ fullView frame ];
    [ fullView retain ];
    [ self updateWindow ];
}
#pragma mark -
#pragma mark TableView related code
- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    int count;
    if (aTableView == tunnelsList )
    {
	return [ self numberOfTunnels ];
    }   
    else if (aTableView == localList && [ self currentTunnel ])
    {
	SSHTunnel *currentTunnel = [ self currentTunnel ];
	count = [[ currentTunnel valueForKey: @"tunnelsLocal" ] count ];
	if (tempLocal)
	    count++;
	return count;
    }
    else if (aTableView == remoteList && [ self currentTunnel ])
    {
	SSHTunnel *currentTunnel = [ self currentTunnel ];
	count = [[ currentTunnel valueForKey: @"tunnelsRemote" ] count ];
	if (tempRemote)
	    count++;
	return count;
    }
    return 0;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
    if (aTableView == tunnelsList )
    {
	if ([[aTableColumn identifier ] isEqual: @"tunnelName" ])
	{
	    SSHTunnel *tunnel = [ tunnels objectAtIndex: rowIndex ];
	    NSString *myName = [ tunnel  valueForKey: @"connName" ];
	    return myName;
	}
    }
    else if (aTableView == localList)
    {
	if (rowIndex == [[[ self currentTunnel ]  valueForKey: @"tunnelsLocal" ] count ])
	    return [ tempLocal objectForKey: [ aTableColumn identifier ]];
	else
	{
	    SSHTunnel *currentTunnel = [ self currentTunnel ];
	    NSArray *localTunnels = [ currentTunnel valueForKey: @"tunnelsLocal" ];
	    NSDictionary *redirect = [ localTunnels objectAtIndex: rowIndex ];
	    return [ redirect objectForKey: [ aTableColumn identifier ]];
	}
    }
    else if (aTableView == remoteList)
    {
	if (rowIndex == [[[ self currentTunnel ] valueForKey: @"tunnelsRemote" ] count ])
	    return [ tempRemote objectForKey: [ aTableColumn identifier ]];
	else
	{
	    SSHTunnel *currentTunnel = [ self currentTunnel ];
	    NSArray *localTunnels = [ currentTunnel valueForKey: @"tunnelsRemote" ];
	    NSDictionary *redirect = [ localTunnels objectAtIndex: rowIndex ];
	    return [ redirect objectForKey: [ aTableColumn identifier ]];
	}
    }
    return nil;
}
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
    if (aTableView == localList || aTableView == remoteList)
    {
	if (aTableView == localList)
	{
	    if (tempLocal)
	    {
		[ tempLocal setObject:anObject forKey:[ aTableColumn identifier ]];
	    }
	    else
		[[ self currentTunnel ] setLocalValue: anObject ofTunnel: [aTableView selectedRow] forKey:[ aTableColumn identifier ]];
	}
	else if (aTableView == remoteList)
	{
	    if (tempRemote)
	    {
		[ tempRemote setObject:anObject forKey:[ aTableColumn identifier ]];
	    }
	    else
		[[ self currentTunnel ] setRemoteValue: anObject ofTunnel: [aTableView selectedRow] forKey:[ aTableColumn identifier ]];
	}
    }
}
- (BOOL)selectionShouldChangeInTableView:(NSTableView *)aTableView
{
    [ self save ];
    return YES;
}
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    if ([ aNotification object] == tunnelsList)
	[ self updateWindow ];
    if ([ aNotification object] == localList)
    {
	if (tempLocal && toAdd)
	{
	    [[ self currentTunnel ] addLocalTunnel: tempLocal ];
	    [ tempLocal release ];
	    tempLocal = nil;
	    toAdd = NO;
	}
	[ self save ];
    }
    if ([ aNotification object] == remoteList)
    {
	if (tempRemote && toAdd)
	{
	    [[ self currentTunnel ] addRemoteTunnel: tempRemote ];
	    [ tempRemote release ];
	    tempRemote = nil;
	    toAdd = NO;
	}
	[ self save ];
    }
}

- (void)save
{
    NSEnumerator *e;
    SSHTunnel *t;
    NSMutableArray *a;
    NSMutableArray *args;
    
    args = [[[ self currentTunnel ] arguments ] mutableCopy ];
    [ args removeObject: @"-v" ];
    [ commandLine setStringValue: [ NSString stringWithFormat: @"ssh %@",[ args componentsJoinedByString: @" " ]]];
    a = [ NSMutableArray array ];
    e = [ tunnels objectEnumerator ];
    while (t = [ e nextObject ])
	[ a addObject: [ t dictionary ]];
    
    [[ NSUserDefaults standardUserDefaults ] setObject: a forKey: @"tunnels" ];
    [[ NSUserDefaults standardUserDefaults ] setObject: [ NSNumber numberWithBool: [ autoOpen state ]] forKey: @"openPalette" ];
    [[ NSNotificationCenter defaultCenter] postNotificationName:@"STMPrefChanged" object: self];
    [[ NSUserDefaults standardUserDefaults ] synchronize ];
}

- (IBAction)controlChanged:(id)sender;
{
    SSHTunnel *t = [ self currentTunnel ];
    if (sender == name)
    {
	[ t setValue: [ sender stringValue ] forKey: @"connName" ];
	[ tunnelsList reloadData ];
    }
    else if (sender == login)
	    [ t setValue: [ sender stringValue ] forKey: @"connUser" ];
    else if (sender == host)
	    [ t setValue: [ sender stringValue ] forKey: @"connHost" ];
    else if (sender == port)
	    [ t setValue: [ sender stringValue ] forKey: @"connPort" ];
    else if (sender == autoConnect)
	[ t setValue: [ NSNumber numberWithBool:[ sender state ]] forKey: @"autoConnect" ];
    else if (sender == handleAuthentication)
	[ t setValue: [ NSNumber numberWithBool:[ sender state ]] forKey: @"connAuth" ];
    else if (sender == compress)
	    [ t setValue: [ NSNumber numberWithBool:[ sender state ]] forKey: @"compression" ];
    else if (sender == forcev1)
	    [ t setValue: [ NSNumber numberWithBool:[ sender state ]] forKey: @"v1" ];
    else if (sender == allowLAN)
	    [ t setValue: [ NSNumber numberWithBool:[ sender state ]] forKey: @"connRemote" ];
    else if (sender == enableSOCKS4)
	    [ t setValue: [ NSNumber numberWithBool:[ sender state ]] forKey: @"socks4" ];
    else if (sender == SOCKS4Port)
	    [ t setValue: [ NSNumber numberWithInt: [ sender intValue ]] forKey: @"socks4p" ];
    else if (sender == cryptMethod)
	    [ t setValue: [ sender titleOfSelectedItem ] forKey: @"encryption" ];
    
    [ self save ];
}
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText*)fieldEditor
{
    NSTableView *table;
    if (control == localList || control == remoteList)
    {
	table = (NSTableView*)control;
	if ([ table editedColumn ] == 0 || [ table editedColumn ] == 2)
	{
	    [ control setIntValue: [ control intValue]];
	    if ([ control intValue ] > 0 &&
		[ control intValue ] < 65536)
	    {
		return YES;
	    }
	    else
		[ control setStringValue: @"" ];
	}
	else if ([ table editedColumn ] == 1)
	{
	    if ([[ control stringValue ] length ] != 0)
		return YES;
	}
    }
    else
	return YES;
    return NO;
}
- (int)numberOfTunnels
{
    return [ tunnels count ];
}
- (IBAction)addHost:(id)sender
{
    [ tunnels addObject: [ SSHTunnel tunnelWithName: @"New Tunnel" ]];
    [ tunnelsList reloadData ];
    [ tunnelsList selectRow:[ tunnels count ] - 1  byExtendingSelection:NO ];
}

- (IBAction)addLocal:(id)sender
{
    tempLocal = [[ NSMutableDictionary dictionary ] retain ];
    [ localList reloadData ];
    [ localList selectRow:[[[ self currentTunnel ] valueForKey: @"tunnelsLocal" ] count ]
     byExtendingSelection:NO];
    [ localList editColumn: 0 
		       row: [[[ self currentTunnel ] valueForKey: @"tunnelsLocal" ] count ] 
		 withEvent: nil 
		    select: YES ];
    toAdd = YES;
}

- (IBAction)addRemote:(id)sender
{
    tempRemote = [[ NSMutableDictionary dictionary ] retain ];
    [ remoteList reloadData ];
    [ remoteList selectRow:[[[ self currentTunnel ] valueForKey: @"tunnelsRemote" ] count ]
     byExtendingSelection:NO];
    [ remoteList editColumn: 0 
		       row: [[[ self currentTunnel ] valueForKey: @"tunnelsRemote" ] count ] 
		 withEvent: nil 
		    select: YES ];
    toAdd = YES;
}

- (IBAction)delHost:(id)sender
{
    [ tunnels removeObject: [ self currentTunnel ]];
    [ tunnelsList reloadData ];
}

- (IBAction)delLocal:(id)sender
{
    if ([ localList selectedRow ] == -1)
	return;
    if ([ localList selectedRow ] == [[[ self currentTunnel ] valueForKey: @"tunnelsLocal" ] count ])
    {
	[ tempLocal release ];
	tempLocal = nil;
    }
    else
    {
	[[ self currentTunnel] removeLocal: [ localList selectedRow ]];
    }
    [ localList reloadData ];
}

- (IBAction)delRemote:(id)sender
{
    if ([ remoteList selectedRow ] == -1)
	return;
    if ([ remoteList selectedRow ] == [[[ self currentTunnel ] valueForKey: @"tunnelsRemote" ] count ])
    {
	[ tempRemote release ];
	tempRemote = nil;
    }
    else
    {
	[[ self currentTunnel] removeRemote: [ remoteList selectedRow ]];
    }
    [ remoteList reloadData ];
}

- (void)updateWindow
{
    NSRect fr;
    [ autoOpen setState: [[[ NSUserDefaults standardUserDefaults ] objectForKey: @"openPalette" ] boolValue ]];
    if ([ tunnelsList selectedRow ] != -1)
    {
	NSMutableArray *args;
	if (empty)
	{
	    fr = [ emptyView frame ];
	    [ emptyView removeFromSuperview ];
	    [[ window contentView ] addSubview: fullView ];
	    [ fullView setFrame: fr ];
	    empty = NO;
	}
	[ name setStringValue: [[ self currentTunnel ] valueForKey: @"connName" ] ];
	[ login setStringValue: [[ self currentTunnel ] valueForKey: @"connUser" ] ];
	[ host setStringValue: [[ self currentTunnel ] valueForKey: @"connHost" ] ];
	[ port setStringValue: [[ self currentTunnel ] valueForKey: @"connPort" ] ];
	
	[ autoConnect setState: [[[ self currentTunnel ] valueForKey: @"autoConnect" ] boolValue]];
	[ handleAuthentication setState: [[[ self currentTunnel ] valueForKey: @"connAuth" ] boolValue]];
	[ compress setState: [[[ self currentTunnel ] valueForKey: @"compression" ]boolValue]];
	[ forcev1 setState: [[[ self currentTunnel ] valueForKey: @"v1" ]boolValue] ];
	[ allowLAN setState: [[[ self currentTunnel ] valueForKey: @"connRemote" ] boolValue]];
	[ enableSOCKS4 setState: [[[ self currentTunnel ] valueForKey: @"socks4" ] boolValue]];
	[ SOCKS4Port setStringValue: [[ self currentTunnel ] valueForKey: @"socks4p" ]];
	[ cryptMethod selectItemWithTitle: [[ self currentTunnel ] valueForKey: @"encryption" ]];
	
	args = [[[ self currentTunnel ] arguments ] mutableCopy ];
	[ args removeObject: @"-v" ];
	[ commandLine setStringValue: [ NSString stringWithFormat: @"ssh %@",[ args componentsJoinedByString: @" " ]]];
	[ args release ];
    }
    else
    {
	fr = [ fullView frame ];
	[ fullView removeFromSuperview ];
	[[ window contentView ] addSubview: emptyView ];
	[ emptyView setFrame: fr ];
	[ options setState: NO ];
	empty = YES;
    }
    
    [ localList reloadData ];
    [ remoteList reloadData ];
    [ self disclosure: self ];
}
- (SSHTunnel*)currentTunnel
{
    if ( [ tunnelsList selectedRow ] != -1)
	return [ tunnels objectAtIndex: [ tunnelsList selectedRow ]];
    return nil;
}
- (IBAction)disclosure:(id)sender
{
    if (! [ options state ])
	[ drawer close ];
    else 
    {
	if ([ self currentTunnel ])
	    [ drawer open ];
	else
	    [ options setState: NO ];
    }
}
- (void)windowWillClose:(NSNotification *)aNotification
{
    NSResponder *r = [ window firstResponder ];
    if ([r isKindOfClass:[NSTextView class]] && [(NSTextView*)r isFieldEditor])
    {
	r = [(NSTextView*)r delegate];
	[ self controlChanged: r ]; 
    }
    [ self save ];
    [ tunnels release ];   
    [ fullView release ];
//    NSLog(@"%i",[ self retainCount ]);
    //[ self autorelease ];
    [ NSApp stopModal ];
}
@end
