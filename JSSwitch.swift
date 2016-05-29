//
//  JSSwitch.swift
//  JSSwitch
//
//  Created by Julien Sagot on 29/05/16.
//  Copyright © 2016 Julien Sagot. All rights reserved.
//

import AppKit

public class JSSwitch: NSControl {
	public override var wantsUpdateLayer: Bool {
		return true
	}

	private var pressed = false
	private let baseHeight: CGFloat = 62
	private let backgroundLayer = CALayer()
	private let knobContainer = CALayer()
	private let knobLayer = CALayer()
	private let knobShadows = (smallStroke: CALayer(), smallShadow: CALayer(), mediumShadow: CALayer(), bigShadow: CALayer())

	public var tintColor = NSColor(deviceRed: 104/255, green: 218/255, blue: 113/255, alpha: 1.0)
	public var on = false {
		didSet { needsDisplay = true }
	}

	// MARK: - Initializers
	public override init(frame: CGRect) {
		super.init(frame: frame)
		setupLayers()
	}

	required public init?(coder: NSCoder) {
		super.init(coder: coder)
		setupLayers()
	}

	// MARK: - Layers Setup
	private func setupLayers() {
		wantsLayer = true
		layer?.masksToBounds = false
		layerContentsRedrawPolicy = .OnSetNeedsDisplay

		// Background
		setupBackgroundLayer()
		layer?.addSublayer(backgroundLayer)

		// Knob
		setupKnobLayers()
		layer?.addSublayer(knobContainer)
	}

	// MARK: Background Layer
	private func setupBackgroundLayer() {
		backgroundLayer.frame = bounds
		backgroundLayer.cornerRadius = ceil(bounds.height / 2)
		backgroundLayer.borderWidth = on ? ceil(backgroundLayer.bounds.height) : 3.0 * ceil(backgroundLayer.bounds.height / baseHeight)
		backgroundLayer.borderColor = on ? tintColor.CGColor : NSColor.blackColor().colorWithAlphaComponent(0.09).CGColor
		backgroundLayer.autoresizingMask = [.LayerWidthSizable, .LayerHeightSizable]
	}

	// MARK: Knob
	private func setupKnobLayers() {
		setupKnobContainerLayer()
		setupKnobLayer()
		setupKnobLayerShadows()
		knobContainer.addSublayer(knobLayer)
		knobContainer.insertSublayer(knobShadows.smallStroke, below: knobLayer)
		knobContainer.insertSublayer(knobShadows.smallShadow, below: knobShadows.smallStroke)
		knobContainer.insertSublayer(knobShadows.mediumShadow, below: knobShadows.smallShadow)
		knobContainer.insertSublayer(knobShadows.bigShadow, below: knobShadows.mediumShadow)
	}

	private func setupKnobContainerLayer() {
		knobContainer.frame = knobFrameForState(on: false, pressed: false)
	}

	private func setupKnobLayer() {
		knobLayer.autoresizingMask = [.LayerWidthSizable]
		knobLayer.backgroundColor = NSColor.whiteColor().CGColor
		knobLayer.frame = knobContainer.bounds
		knobLayer.cornerRadius = ceil(knobContainer.bounds.height / 2)
	}

	private func setupKnobLayerShadows() {
		let effectScale = backgroundLayer.bounds.height / baseHeight
		// Small Stroke
		let smallStroke = knobShadows.smallStroke
		smallStroke.frame = knobLayer.frame.insetBy(dx: -1, dy: -1)
		smallStroke.autoresizingMask = [.LayerWidthSizable]
		smallStroke.backgroundColor = NSColor.blackColor().colorWithAlphaComponent(0.06).CGColor
		smallStroke.cornerRadius = ceil(smallStroke.bounds.height / 2)

		let smallShadow = knobShadows.smallShadow
		smallShadow.frame = knobLayer.frame.insetBy(dx: 1.5, dy: 1.5)
		smallShadow.autoresizingMask = [.LayerWidthSizable]
		smallShadow.cornerRadius = ceil(smallShadow.bounds.height / 2)
		smallShadow.backgroundColor = NSColor.redColor().CGColor
		smallShadow.shadowColor = NSColor.blackColor().CGColor
		smallShadow.shadowOffset = CGSize(width: 0, height: -2 * effectScale)
		smallShadow.shadowOpacity = 0.12
		smallShadow.shadowRadius = 2.0 * effectScale

		let mediumShadow = knobShadows.mediumShadow
		mediumShadow.frame = smallShadow.frame
		mediumShadow.autoresizingMask = [.LayerWidthSizable]
		mediumShadow.cornerRadius = smallShadow.cornerRadius
		mediumShadow.backgroundColor = NSColor.redColor().CGColor
		mediumShadow.shadowColor = NSColor.blackColor().CGColor
		mediumShadow.shadowOffset = CGSize(width: 0, height: -8 * effectScale)
		mediumShadow.shadowOpacity = 0.16
		mediumShadow.shadowRadius = 6.0 * effectScale

		let bigShadow = knobShadows.bigShadow
		bigShadow.frame = smallShadow.frame
		bigShadow.autoresizingMask = [.LayerWidthSizable]
		bigShadow.cornerRadius = smallShadow.cornerRadius
		bigShadow.backgroundColor = NSColor.redColor().CGColor
		bigShadow.shadowColor = NSColor.blackColor().CGColor
		bigShadow.shadowOffset = CGSize(width: 0, height: -8 * effectScale)
		bigShadow.shadowOpacity = 0.06
		bigShadow.shadowRadius = 0.5 * effectScale
	}

	// MARK: - Drawing
	public override func updateLayer() {
		// Background
		backgroundLayer.frame = bounds
		backgroundLayer.cornerRadius = ceil(bounds.height / 2)
		backgroundLayer.borderWidth = on ? ceil(backgroundLayer.bounds.height) : 3.0 * ceil(backgroundLayer.bounds.height / baseHeight)
		backgroundLayer.borderColor = on ? tintColor.CGColor : NSColor.blackColor().colorWithAlphaComponent(0.09).CGColor

		// Knob
		knobContainer.frame = knobFrameForState(on: on, pressed: pressed)
		knobLayer.cornerRadius = ceil(knobContainer.bounds.height / 2)
	}

	// MARK: - Helpers
	private func knobFrameForState(on on: Bool, pressed: Bool) -> CGRect {
		let borderWidth = 3.0 * ceil(backgroundLayer.bounds.height / baseHeight)
		var origin: CGPoint
		var size: CGSize {
			if pressed {
				return CGSize(
					width: ceil(backgroundLayer.bounds.height * 1.31) - (2 * borderWidth),
					height: backgroundLayer.bounds.height - (2 * borderWidth)
				)
			}
			return CGSize(width: backgroundLayer.bounds.height - (2 * borderWidth), height: backgroundLayer.bounds.height - (2 * borderWidth))
		}

		if on {
			origin = CGPoint(x: backgroundLayer.bounds.width - size.width - borderWidth, y: borderWidth)
		} else {
			origin = CGPoint(x: borderWidth, y: borderWidth)
		}
		return CGRect(origin: origin, size: size)
	}

	// MARK: - Events
	public override func mouseDown(theEvent: NSEvent) {
		pressed = true
		needsDisplay = true
	}

	public override func mouseUp(theEvent: NSEvent) {
		pressed = false
		on = !on
	}
}
