//
//  AudioItem.swift
//  SwiftAudio
//
//  Created by Jørgen Henrichsen on 18/03/2018.
//

import Foundation
import AVFoundation
import UIKit

public enum SourceType {
    case stream
    case file
}

public protocol AudioItem {
    func getSourceId() -> String?
    func getSourceUrl() -> String
    func getArtist() -> String?
    func getTitle() -> String?
    func getAlbumTitle() -> String?
    func getArtworkUrl() -> String?
    func getSourceType() -> SourceType
    func getArtwork(_ handler: @escaping (UIImage?) -> Void)
    
}

/// Make your `AudioItem`-subclass conform to this protocol to control which AVAudioTimePitchAlgorithm is used for each item.
public protocol TimePitching {
    
    func getPitchAlgorithmType() -> AVAudioTimePitchAlgorithm
    
}

/// Make your `AudioItem`-subclass conform to this protocol to control enable the ability to start an item at a specific time of playback.
public protocol InitialTiming {
    func getInitialTime() -> TimeInterval
}

/// Make your `AudioItem`-subclass conform to this protocol to set initialization options for the asset. Available keys available at [Apple Developer Documentation](https://developer.apple.com/documentation/avfoundation/avurlasset/initialization_options).
public protocol AssetOptionsProviding {
    func getAssetOptions() -> [String: Any]
}

public class DefaultAudioItem: AudioItem {

    public var audioUrl: String
    
    public var audioId: String?
    
    public var artist: String?
    
    public var title: String?
    
    public var albumTitle: String?
    
    public var artworkUrl: String?
    
    public var sourceType: SourceType
    
    public var artwork: UIImage?
    
    public init(audioUrl: String,
                audioId: String? = nil,
                artist: String? = nil,
                title: String? = nil,
                albumTitle: String? = nil,
                artworkUrl: String? = nil,
                sourceType: SourceType,
                artwork: UIImage? = nil) {
        self.audioUrl = audioUrl
        self.audioId = audioId
        self.artist = artist
        self.title = title
        self.albumTitle = albumTitle
        self.artworkUrl = artworkUrl
        self.sourceType = sourceType
        self.artwork = artwork
    }
    
    public func getSourceId() -> String? {
        return audioId
    }
    
    public func getSourceUrl() -> String {
        return audioUrl
    }
    
    public func getArtist() -> String? {
        return artist
    }
    
    public func getTitle() -> String? {
        return title
    }
    
    public func getAlbumTitle() -> String? {
        return albumTitle
    }
    
    public func getArtworkUrl() -> String? {
        return artworkUrl
    }
    
    public func getSourceType() -> SourceType {
        return sourceType
    }

    public func getArtwork(_ handler: @escaping (UIImage?) -> Void) {
        handler(artwork)
    }
    
}

/// An AudioItem that also conforms to the `TimePitching`-protocol
public class DefaultAudioItemTimePitching: DefaultAudioItem, TimePitching {
    
    public var pitchAlgorithmType: AVAudioTimePitchAlgorithm
    
    public override init(audioUrl: String,
                         audioId: String?,
                         artist: String?,
                         title: String?,
                         albumTitle: String?,
                         artworkUrl: String?,
                         sourceType: SourceType,
                         artwork: UIImage?) {
        self.pitchAlgorithmType = AVAudioTimePitchAlgorithm.lowQualityZeroLatency
        super.init(audioUrl: audioUrl,
                   audioId: audioId,
                   artist: artist,
                   title: title,
                   albumTitle: albumTitle,
                   sourceType: sourceType,
                   artwork: artwork)
    }
    
    public init(audioUrl: String,
                audioId: String?,
                artist: String?,
                title: String?,
                albumTitle: String?,
                artworkUrl: String?,
                sourceType: SourceType,
                artwork: UIImage?,
                audioTimePitchAlgorithm: AVAudioTimePitchAlgorithm) {
        self.pitchAlgorithmType = audioTimePitchAlgorithm
        super.init(audioUrl: audioUrl,
                   audioId: audioId,
                   artist: artist,
                   title: title,
                   albumTitle: albumTitle,
                   sourceType: sourceType,
                   artwork: artwork)
    }
    
    public func getPitchAlgorithmType() -> AVAudioTimePitchAlgorithm {
        return pitchAlgorithmType
    }
}

/// An AudioItem that also conforms to the `InitialTiming`-protocol
public class DefaultAudioItemInitialTime: DefaultAudioItem, InitialTiming {
    
    public var initialTime: TimeInterval
    
    public override init(audioUrl: String,
                         audioId: String?,
                         artist: String?,
                         title: String?,
                         albumTitle: String?,
                         artworkUrl: String?,
                         sourceType: SourceType,
                         artwork: UIImage?) {
        self.initialTime = 0.0
        super.init(audioUrl: audioUrl,
                   audioId: audioId,
                   artist: artist,
                   title: title,
                   albumTitle: albumTitle,
                   sourceType: sourceType,
                   artwork: artwork)
    }
    
    public init(audioUrl: String,
                audioId: String?,
                artist: String?,
                title: String?,
                albumTitle: String?,
                artworkUrl: String?,
                sourceType: SourceType,
                artwork: UIImage?,
                initialTime: TimeInterval) {
        self.initialTime = initialTime
        super.init(audioUrl: audioUrl,
                   audioId: audioId,
                   artist: artist,
                   title: title,
                   albumTitle: albumTitle,
                   sourceType: sourceType,
                   artwork: artwork)
    }
    
    public func getInitialTime() -> TimeInterval {
        return initialTime
    }
    
}

/// An AudioItem that also conforms to the `AssetOptionsProviding`-protocol
public class DefaultAudioItemAssetOptionsProviding: DefaultAudioItem, AssetOptionsProviding {
    
    public var options: [String: Any]
    
    public override init(audioUrl: String,
                         audioId: String?,
                         artist: String?,
                         title: String?,
                         albumTitle: String?,
                         artworkUrl: String?,
                         sourceType: SourceType,
                         artwork: UIImage?) {
        self.options = [:]
        super.init(audioUrl: audioUrl,
                   audioId: audioId,
                   artist: artist,
                   title: title,
                   albumTitle: albumTitle,
                   artworkUrl: artworkUrl,
                   sourceType: sourceType,
                   artwork: artwork)
    }
    
    public init(audioUrl: String,
                audioId: String?,
                artist: String?,
                title: String?,
                albumTitle: String?,
                artworkUrl: String?,
                sourceType: SourceType,
                artwork: UIImage?,
                options: [String: Any]) {
        self.options = options
        super.init(audioUrl: audioUrl,
                   audioId: audioId,
                   artist: artist,
                   title: title,
                   albumTitle: albumTitle,
                   sourceType: sourceType,
                   artwork: artwork)
    }
    
    public func getAssetOptions() -> [String: Any] {
        return options
    }
    
}
