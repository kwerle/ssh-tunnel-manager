/* PreferencesController */

#import <Cocoa/Cocoa.h>
#import "SSHTunnel.h"
@interface PreferencesController : NSObject
{
    IBOutlet id allowLAN;
    IBOutlet id autoConnect;
    IBOutlet id compress;
    IBOutlet id cryptMethod;
    IBOutlet id options;
    IBOutlet id drawer;
    IBOutlet id emptyView;
    IBOutlet id enableSOCKS4;
    IBOutlet id forcev1;
    IBOutlet id fullView;
    IBOutlet id handleAuthentication;
    IBOutlet id host;
    IBOutlet id localList;
    IBOutlet id login;
    IBOutlet id name;
    IBOutlet id port;
    IBOutlet id remoteList;
    IBOutlet id SOCKS4Port;
    IBOutlet id tunnelsList;
    IBOutlet id window;
    IBOutlet id autoOpen;
    IBOutlet id urlTextField;
    IBOutlet id commandLine;
    
    NSMutableArray *tunnels;
    NSRect mainFrameRect;
    
    NSMutableDictionary *tempLocal;
    NSMutableDictionary *tempRemote;
    BOOL toAdd;
    BOOL empty;
}
- (int)numberOfTunnels;
- (void)updateWindow;
- (SSHTunnel*)currentTunnel;

- (IBAction)addHost:(id)sender;
- (IBAction)addLocal:(id)sender;
- (IBAction)addRemote:(id)sender;
- (IBAction)controlChanged:(id)sender;
- (IBAction)delHost:(id)sender;
- (IBAction)delLocal:(id)sender;
- (IBAction)delRemote:(id)sender;
- (IBAction)disclosure:(id)sender;

- (void)save;
@end
