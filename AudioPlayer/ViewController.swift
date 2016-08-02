//
//  ViewController.swift
//  AudioPlayer
//
//  Created by Gerardo Villarroel on 27-07-16.
//  Copyright © 2016 Gerardo Villarroel. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var btnPlayAleatorio: UIBarButtonItem!
    @IBOutlet weak var btnStop: UIBarButtonItem!
    @IBOutlet weak var foto: UIImageView!
    
    @IBOutlet weak var volumeDown: UIButton!
    @IBOutlet weak var volumeSlide: UISlider!
    @IBOutlet weak var volumeUp: UIButton!
    @IBOutlet weak var tituloDeLaCancion: UITextField!
    
    @IBOutlet weak var timeUp: UILabel!
    @IBOutlet weak var timeSlide: UISlider!
    @IBOutlet weak var timeDown: UILabel!

    private var reproductor: AVAudioPlayer!
    private var timer = NSTimer()
    var storage = 0
    var tema = RocolaStorage()
    var currentTime = String()
    var maximumValue = String()
    var playAleatorio = false
    var playAleatorioStack = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        llenarPlayAleatorioStack()
        volumeSlide.value = tema.volumenCancion
        colorPlayAleatorio()
        montarTemaNuevo()
    }
    
    private func llenarPlayAleatorioStack() {
        for i in 0...tema.listadoDeCanciones.count - 1 {
            playAleatorioStack.append(i)
        }
    }
    
    private func montarTemaNuevo() {
        let sonidoURL = NSBundle.mainBundle().URLForResource(tema.listadoArtistas[storage], withExtension: "mp3")
        foto.image = UIImage(named: tema.listadoArtistas[storage])
        do {
            try reproductor = AVAudioPlayer(contentsOfURL: sonidoURL!)
            reproductor.volume = volumeSlide.value
            tituloDeLaCancion.text = tema.listadoDeCanciones[storage]
            if reproductor.duration < 30 {
                timeSlide.maximumValue = Float(reproductor.duration / 2)
            } else {
                timeSlide.maximumValue = Float(reproductor.duration)
            }
            maximumValue = tema.stringFromTimeInterval(NSTimeInterval(timeSlide.maximumValue))
            interval()
            playMusic()
        }
        catch {
            print("Error al cargar el archivo de sonido")
        }
    }
    
    @IBAction func playAleatorio(sender: UIBarButtonItem) {
        colorPlayAleatorio()
    }
    
    private func colorPlayAleatorio() {
        if btnPlayAleatorio.tintColor == UIColor.blackColor() {
            btnPlayAleatorio.tintColor = UIColor.blueColor()
            escojerTemaAleatorio()
        } else {
            btnPlayAleatorio.tintColor = UIColor.blackColor()
        }
    }
    
    private func escojerTemaAleatorio() {
        var nuevoTema = Int()
        nuevoTema = Int(arc4random_uniform(UInt32(playAleatorioStack.count)))
        storage = playAleatorioStack[nuevoTema]
        playAleatorioStack.removeAtIndex(nuevoTema)
        if playAleatorioStack.isEmpty {
            llenarPlayAleatorioStack()
        }
        montarTemaNuevo()
    }
    
    @IBAction func playPause(sender: AnyObject) {
        if !reproductor.playing {
            playMusic()
        } else {
            reproductor.pause()
            timer.invalidate()
            changePlayPause(false)
        }
    }
    
    private func playMusic() {
        reproductor.prepareToPlay()
        reproductor.play()
        timerInit()
        changePlayPause(true)
        statusStop(true)
        playAleatorio = false
    }
    
    private func changePlayPause(change: Bool) {
        if change {
            let btnPause = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: #selector(ViewController.playPause))
            toolBar.items![4] = btnPause
        } else {
            let btnPlay = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Play, target: self, action: #selector(ViewController.playPause))
            toolBar.items![4] = btnPlay
        }
    }
    
    @IBAction func stop() {
        stopPlaying()
    }
    
    private func statusStop(status: Bool) {
        btnStop.enabled = status
    }
    
    private func stopPlaying() {
        reproductor.stop()
        reproductor.currentTime = 0
        timer.invalidate()
        timeSlide.value = 0
        changePlayPause(false)
        statusStop(false)
        refreshContadores()
    }
    
    @IBAction func temaAnterior(sender: UIBarButtonItem) {
        btnPlayAleatorio.tintColor = UIColor.blackColor()
        stopPlaying()
        if storage == 0 {
            storage = tema.listadoDeCanciones.count - 1
        } else {
            storage -= 1
        }
        montarTemaNuevo()
    }
    
    @IBAction func temaSiguiente(sender: UIBarButtonItem) {
        btnPlayAleatorio.tintColor = UIColor.blackColor()
        stopPlaying()
        cargarTemaSiguiente()
        montarTemaNuevo()
    }
    
    private func cargarTemaSiguiente() {
        if storage == tema.listadoDeCanciones.count - 1 {
            storage = 0
        } else {
            storage += 1
        }
    }
    
    @IBAction func volume(sender: AnyObject) {
        if sender is UIButton {
            if sender.currentTitle == "🔊" {
                self.volumeSlide.value += 0.1
            } else {
                self.volumeSlide.value -= 0.1
            }
            reproductor.volume = self.volumeSlide.value
            tema.volumenCancion = self.volumeSlide.value
        } else {
            reproductor.volume = sender.value
            tema.volumenCancion = sender.value
        }
    }
    
    @IBAction func trackSlide(sender: UISlider) {
        if !reproductor.playing {
            playMusic()
        }
        reproductor.stop()
        reproductor.currentTime = NSTimeInterval(sender.value)
        interval()
        reproductor.prepareToPlay()
        reproductor.play()
    }
    
    override func viewWillDisappear(animated: Bool) {
        stopPlaying()
    }
    
    private func timerInit() {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(ViewController.interval), userInfo: nil, repeats: true)
    }

    @objc private func interval() {
        refreshContadores()
        timeSlide.value = Float(reproductor.currentTime)
        if timeSlide.value == 0 {
            stopPlaying()
        }
        if btnPlayAleatorio.tintColor == UIColor.blueColor() && currentTime == maximumValue {
            if !playAleatorio {
                refreshRelojes()
                playAleatorio = true
                escojerTemaAleatorio()
            }
        } else if currentTime == maximumValue {
            refreshRelojes()
            cargarTemaSiguiente()
            montarTemaNuevo()
        }
    }
    
    private func refreshRelojes() {
        currentTime = ""
        maximumValue = ""
    }
    
    private func refreshContadores() {
        let duration = NSTimeInterval(timeSlide.maximumValue) - reproductor.currentTime
        timeUp.text = tema.stringFromTimeInterval(reproductor.currentTime as NSTimeInterval)
        timeDown.text = tema.stringFromTimeInterval(duration as NSTimeInterval)
        if timeUp.text == maximumValue {
            currentTime = timeUp.text!
        }
    }
}

