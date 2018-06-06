//
//  OurSegmentedControl.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 05/06/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

protocol OurSegmentedControlDelegate: NSObjectProtocol {
    
    func tintColorFor(_ index: Int, isSelected: Bool) -> UIColor?
    func backgroundColorFor(_ index: Int, isSelected: Bool) -> UIColor?

}

class OurSegmentedControl: UISegmentedControl {
    
    weak var delegate: OurSegmentedControlDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateSegmentColors()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.updateSegmentColors()
    }
    
    func updateSegmentColors() {
//        let segments = self.subviews.sorted(by: { obj1, obj2 in
//            // UISegmentedControl segments use UISegment objects (private API). But we can safely cast them to UIView objects.
//            let origin1 = Float((obj1 as UIView).frame.origin.x )
//            let origin2 = Float((obj2 as UIView).frame.origin.x )
//            if origin1 < origin2 {
//                return true
//            } else if origin1 > origin2 {
//                return false
//            } else {
//                return true
//            }
//        })
//        var isSelected: Bool
//        var color: UIColor
////        self.backgroundColor = UIColor.white
//        for index in 0..<segments.count {
//            if index == 0 || index == segments.count - 1 {
//                segments[index].layer.cornerRadius = 4.5
//            }
//            isSelected = self.selectedSegmentIndex == index
////            color = delegate?.backgroundColorFor(index, isSelected: isSelected) ?? self.backgroundColor!
//            segments[index].tintColor = delegate?.tintColorFor(index, isSelected: isSelected) ?? self.tintColor
////            segments[index].backgroundColor = UIColor.clear
////            if isSelected {
////                for subview in segments[index].subviews where ((subview as? UILabel) != nil) {
//////                    subview.tintColor = UIColor.green
////                    subview.setValue(UIColor.green, forKey: "tintColor")
////                }
////            }
//        }
    }
    
    func setText(color: UIColor) {
        
    }
}
