//
//  MetalRenderView.swift
//  MetalQuinnPractices
//
//  Created by Quinn on 2018/11/7.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit
class MetalRenderView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareRender()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareRender()
    }
    
    //编译环境为真机，或者Generic iOS Device，否则报错
    var metalLayer: CAMetalLayer {
        return layer as! CAMetalLayer
    }
    //layerClass 表示此View的layer对象类型，这里设为CAMetalLayer
    override class var layerClass:AnyClass{
        return CAMetalLayer.self
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        render()
    }
    
    var device:MTLDevice!
    var commandQueue : MTLCommandQueue!
    var vertexBuffer : MTLBuffer!
    var piplineState : MTLRenderPipelineState!
    
    var texture_vertexBuffer : MTLBuffer!
    var texture_piplineState : MTLRenderPipelineState!
    var texture: MTLTexture!

    func prepareRender() {
        creatDevice()
        creatPipleineState()
        creatCommandQueue()
        creatRenderBuffer()
        
        setupTexture()
        creatTexturePipleineState()
        creatTextureRenderBuffer()
        
        assert(device != nil)
        assert(piplineState != nil)
        assert(texture_piplineState != nil)

        assert(commandQueue != nil)
        assert(vertexBuffer != nil)

    }
    func creatDevice(){
        guard let device = MTLCreateSystemDefaultDevice() else{
            return
        }
        self.device = device
    }
    
    func creatPipleineState() {
        let library = device.makeDefaultLibrary()
        
        let renderPiplineDiscriptor = MTLRenderPipelineDescriptor()
        renderPiplineDiscriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
        renderPiplineDiscriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
        renderPiplineDiscriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        
        piplineState = try? device.makeRenderPipelineState(descriptor: renderPiplineDiscriptor)
    }
    func creatTexturePipleineState() {
        let library = device.makeDefaultLibrary()
        
        let renderPiplineDiscriptor = MTLRenderPipelineDescriptor()
        renderPiplineDiscriptor.vertexFunction = library?.makeFunction(name: "vertexShaderTexture")
        renderPiplineDiscriptor.fragmentFunction = library?.makeFunction(name: "fragmentShaderTexture")
        renderPiplineDiscriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        
        texture_piplineState = try? device.makeRenderPipelineState(descriptor: renderPiplineDiscriptor)
    }
    func creatCommandQueue(){
        commandQueue = device.makeCommandQueue()
    }
    func render(){
        guard let drawable = metalLayer.nextDrawable() else {
            return
        }
        guard let commandBuffer = commandQueue.makeCommandBuffer() else{
            return
        }

        let renderPassDiscriptor = getRenderPassDoscriptor(drawable:drawable)

        //绘制三角形
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDiscriptor)
        commandEncoder?.setRenderPipelineState(piplineState)
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        commandEncoder?.endEncoding()
        
        //绘制图片
//        let texture_commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDiscriptor)
//        texture_commandEncoder?.setRenderPipelineState(texture_piplineState)
//        texture_commandEncoder?.setVertexBuffer(texture_vertexBuffer, offset: 0, index: 0)
//        texture_commandEncoder?.setFragmentTexture(texture, index: 0)
//        texture_commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
//        texture_commandEncoder?.endEncoding()
        
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

    func creatRenderBuffer(){
        let vertexs = [PositionColor.init(position: [0.5,-0.5], color: [1,0,0,1]),
                       PositionColor.init(position: [-0.5,0.5], color: [0,1,0,1]),
                       PositionColor.init(position: [-0.5,-0.5], color: [0,0,1,1])]
        vertexBuffer = device.makeBuffer(bytes: vertexs, length: MemoryLayout<PositionColor>.size*vertexs.count, options: .cpuCacheModeWriteCombined)
    }
//    PositionTexture.init(position: [-0.5,-0.5], texture: [0,0]),
//    PositionTexture.init(position: [0.5,-0.5], texture: [1,0]),
//    PositionTexture.init(position: [0.5,0.5], texture: [1,1]),
    func creatTextureRenderBuffer(){
        let vertexs = [PositionTexture.init(position: [-0.5,0.5], texture: [0,1]),
                       PositionTexture.init(position: [0.5,0.5], texture: [1,1]),
                       PositionTexture.init(position: [0.5,-0.5], texture: [1,0])]
        texture_vertexBuffer = device.makeBuffer(bytes: vertexs, length: MemoryLayout<PositionTexture>.size*vertexs.count, options: .cpuCacheModeWriteCombined)
    }
    
    
    func getRenderPassDoscriptor(drawable:CAMetalDrawable)->MTLRenderPassDescriptor{
        let renderPassDiscriptor = MTLRenderPassDescriptor()
        renderPassDiscriptor.colorAttachments[0].clearColor = .init(red: 0, green: 1, blue: 0, alpha: 1)
        renderPassDiscriptor.colorAttachments[0].loadAction = .clear
        renderPassDiscriptor.colorAttachments[0].storeAction = .store
        renderPassDiscriptor.colorAttachments[0].texture = drawable.texture
        return renderPassDiscriptor
    }
    
    
}


extension MetalRenderView{
    func setupTexture() {
        let image = UIImage.init(named: "1")
        texture = newTexture(with: image)
    }
    func newTexture(with image: UIImage?) -> MTLTexture? {
        let imageRef = (image?.cgImage)!
        let width = imageRef.width
        let height = imageRef.width
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let rawData = calloc(height * width * 4, MemoryLayout<UInt8>.size)
        let bytesPerPixel: Int = 4
        let bytesPerRow: Int = bytesPerPixel * width
        let bitsPerComponent: Int = 8
        let bitmapContext = CGContext(data: rawData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        bitmapContext?.draw(imageRef, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm,
                                                                         width: width,
                                                                         height: height,
                                                                         mipmapped: false)
        let texture: MTLTexture? = device.makeTexture(descriptor: textureDescriptor)
        let region: MTLRegion = MTLRegionMake2D(0, 0, width, height)
        texture?.replace(region: region, mipmapLevel: 0, withBytes: rawData!, bytesPerRow: bytesPerRow)
        free(rawData)
        return texture
    }
}
