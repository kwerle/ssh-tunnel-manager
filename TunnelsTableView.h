/* TunnelsTableView */

#import <Cocoa/Cocoa.h>

@interface TunnelsTableView : NSTableView
{
    BOOL selectionActive;
}
- (void)setSelectionActive:(BOOL)state;
- (NSColor *)_highlightColorForCell:(NSCell *)cell;
@end
