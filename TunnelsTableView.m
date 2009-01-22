#import "TunnelsTableView.h"

@implementation TunnelsTableView

- (id)initWithCoder:(NSCoder*)coder{
    self = [ super initWithCoder: coder ];
    [ self setSelectionActive: YES ];
    return self;
}

- (void)setSelectionActive:(BOOL)state
{
    selectionActive = state;
}
- (void)highlightSelectionInClipRect:(NSRect)clipRect
{
    NSColor *evenColor = [NSColor colorWithCalibratedRed:0.929 green:0.953 blue:0.996 alpha:1.0];
    NSColor *oddColor  = [NSColor whiteColor];
    
    float rowHeight = [self rowHeight] + [self intercellSpacing].height;
    NSRect visibleRect = [self visibleRect];
    NSRect highlightRect;
    
    highlightRect.origin = NSMakePoint(NSMinX(visibleRect), (int)(NSMinY(clipRect)/rowHeight)*rowHeight);
    highlightRect.size = NSMakeSize(NSWidth(visibleRect), rowHeight - [self intercellSpacing].height);
    
    while (NSMinY(highlightRect) < NSMaxY(clipRect))
    {
	NSRect clippedHighlightRect = NSIntersectionRect(highlightRect, clipRect);
	int row = (int)((NSMinY(highlightRect)+rowHeight/2.0)/rowHeight);
	NSColor *rowColor = (0 == row % 2) ? evenColor : oddColor;
	[rowColor set];
	NSRectFill(clippedHighlightRect);
	highlightRect.origin.y += rowHeight;
    }
    if (selectionActive)
	[super highlightSelectionInClipRect: clipRect];	// call superclass's behavior
}
- (NSColor *)_highlightColorForCell:(NSCell *)cell;
{
    if (selectionActive)
	return [ (TunnelsTableView*)super _highlightColorForCell: cell ];
    else
	return nil;
}
@end
