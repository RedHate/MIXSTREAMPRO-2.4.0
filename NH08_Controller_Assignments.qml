import airAssignments 1.0
import ControlSurfaceModules 0.1
import QtQuick 2.12
import Planck 1.0
import InputAssignment 0.1
import OutputAssignment 0.1
import StateMap 1.0


MidiAssignment {


	// Action.Quantize
	// Action.InstantDouble
	// Action.KeySync
	// Action.ShowSoundSwitchView
	// Action.SwapDeckInfos
	// Action.ToggleControlCenter
	// Action.ToggleUserProfile
	// Action.Scratch
	// Action.GridEdit
	// Action.GridCueEdit
	// Action.SetCuePoint
	// Action.Backtrack
	// Action.SwapDeckInfos
	// Action.SwitchMainViewLayout


	//Planck.isBeta: 1
	//model: 4

	objectName: 'MIXSTREAM PRO Controller Assignment'

	Utility {
		id: util
	}

	GlobalAssignmentConfig {
		id: globalConfig
		midiChannel: 15
	}

	GlobalAction {
		id: globalAction
	}

	Back {
		note: 3
	}

	MidiLearn{
		//stopRecPlayNote: 7
		//startRecNote: 7
		//startPlayNote: 7
	}

	BrowseEncoder {
		pushNote: 6
		turnCC: 5
		///doubleTapAction: Action.InstantDouble //this HAS TO BE HERE the sync mode instant double mode which is broken atm it fucks with the browse knob
	}

	Menu {
		note: 7
	}

	// sniffed out all the extra params and set them to base values for now.
	View {
		note: 16
		shiftAction: Action.SwitchMainViewLayout
		doubleAction: Action.GridCueEdit
		holdAction: Action.None
		shiftHoldAction: Action.None
		ledType: LedType.None
	}

	// replaced "menu" with lighting, on the mixstream they both go to the same place so why have a giant block of shit for it?
	Lighting {
		note: 34
	}
	
	Mixer {
		cueMixCC: 9
		cueGainCC: 10
		crossfaderCC: 14
		masterCC: 15
		speakerCC: 17
	}

	VUMeter {
		dBThresholds: [-35.0, -25.0, -21.0, -15.0, -3.0, 30.0]
		ledCCValues: [0, 14, 27, 40, 53, 66]
		vuMeterType: VUMeterType.Combo
		vuLedCCIndexing: VULedCCIndexing.Incremental
		model: ListModel {
			ListElement {
				channelName: '1'
				cc: 32
			}
			ListElement {
				channelName: '2'
				cc: 33
			}
		}
	}

	// DECKS 4 deck mode needs haslayers flag enabled and numberofdecks set to 4.
	Repeater {
		model: ListModel {
			ListElement {
				deckName: 'Left'
				deckMidiChannel: 2
				loadNote: 1
			}

			ListElement {
				deckName: 'Right'
				deckMidiChannel: 3
				loadNote: 2
			}
		}

		Item {
			
			objectName: 'Deck %1'.arg(model.deckName)

			DeckAssignmentConfig {
				id: deckConfig
				name: model.deckName
				midiChannel: model.deckMidiChannel
			}

			DeckAction {
				id: deckAction
			}

			Load {
				note: model.loadNote
			}

			Sync {
				syncNote: 8
				//syncHoldAction: Action.InstantDouble //currently broken it seems to interfere with the browse knob, odd bug
			}

			PlayCue {
			//	cueNote: 9
				playNote: 10
			//	cueShiftAction: Action.Backtrack
			}

			// added slicer mode to the banks
			PerformanceModes {
				ledType: LedType.Simple
				modesModel: ListModel {
					ListElement {
						note: 11
						view: 'CUES'
						hasBank: true
						shiftView: 'FIXED'
					}
					ListElement {
						note: 12
						view: 'LOOPS'
						hasBank: true
						shiftView: 'SLICER'
					}
					ListElement {
						view: 'AUTO'
						note: 14
						hasBank: true
						shiftView: 'SAMPLER'
					}
					ListElement {
						note: 13
						view: 'ROLL'
						hasBank: true
						shiftView: 'SIMPLE_ROLL'
					}
				}
			}

			ActionPads {
				firstPadNote: 15
				ledType: LedType.Simple
			}

			Shift {
				note: 28
			}

			JogWheel {
				touchNote: 33
				ccUpper: 0x37
				ccLower: 0x4D
				jogSensitivity: 1638.7 * 3.6
				//hasTrackSearch: true //this is that annoying fast jog bull shit it's not needed it also stops cueeditgrid from working
			}
			
			SpeedSlider {
				ccUpper: 0x1F
				ccLower: 0x4B
			}

			// Disabled and repurposed for parameter left and deck switch
			//PitchBend {
			//	minusNote: 29
			//	plusNote: 30
			//}

			// Cant figure out where to put this, i need to code some conditional logic for things that could potentially share the pitch bend buttons
			//BeatJump {
			//	prevNote: 29
			//	nextNote: 30
			//}

			// this is the deck switch button
			Layer {
				note: 9 //cue button
				midiChannel: deckConfig.midiChannel
			}

			// this used to be "wheel" but wheel has less functionality, by using "vinyl" over "wheel" we can utilize the GridCueEdit feature with shift + scratch
			Vinyl {
				note: 35 //scratch button
				holdAction: Action.GridCueEdit
				shiftAction: Action.GridEdit
			}

			// disabled in favor of the vinyl button described above
			//Wheel {
			//	note: 35
			//	shiftAction: Action.Scratch
			//	holdAction: Action.GridEdit
			//}

			// this is the left parameter button used for setting active loops, i will end up using active looping more than i will beat jumping.
			Parameter {
				leftNote:  29 //set to minus button
				rightNote: 30 //set to plus button
			}
		}
	}

	// SWEEPFX needs sweepfx enable flag in binary
	SweepFxSelect {
		midiChannel: 4
		channelNames: ['1', '2', '3', '4']
		flashOnActive: false
		buttonsModel: ListModel {
			Component.onCompleted: {
				const types = [
					{'note': 0, 'fxIndex': SweepEffect.DualFilter},
					{'note': 1, 'fxIndex': SweepEffect.Wash},
					//{'note': 2, 'fxIndex': SweepEffect.Bypass}, 	//DubEcho 		(causes crash)
					//{'note': 3, 'fxIndex': SweepEffect.Bypass}, 	//NoiseSweep	(causes crash)
					//SweepFx 		(causes crash)
					//DualFilter 	(causes crash)
					//FilterRoll 	(causes crash)
					//Wash 			(causes crash)
					//DubEcho 		(causes crash)
					//NoiseSweep 	(causes crash)
				]
				for(const type of types) {
					append({'note': type.note, 'fxIndex': type.fxIndex})
				}
			}
		}
	}

	// MIXER
	Repeater {
		model: ListModel {
			ListElement {
				mixerChannelName: '1'
				mixerChannelMidiChannel: 0
			}
			ListElement {
				mixerChannelName: '2'
				mixerChannelMidiChannel: 1
			}
			ListElement {
				mixerChannelName: '3'
				mixerChannelMidiChannel: 0
			}
			ListElement {
				mixerChannelName: '4'
				mixerChannelMidiChannel: 1
			}
		}

		Item {
			objectName: 'Mixer Channel %1'.arg(model.mixerChannelName)

			MixerChannelAssignmentConfig {
				id: mixerChannelConfig
				name: model.mixerChannelName
				midiChannel: model.mixerChannelMidiChannel
			}

			MixerChannelCore {
				pflNote: 13
				trimCC: 3
				trebleCC: 4
				midCC: 6
				bassCC: 8
				faderCC: 14
			}

			SweepFxKnob {
				cc: 11
			}
		}
	}

	// DjFX needs DjFX enable flag in binary
	Repeater {
		model: ListModel {
			ListElement {
				fxChannelName: '1'
				fxChannelMidiChannel: 0
			}
			ListElement {
				fxChannelName: '2'
				fxChannelMidiChannel: 1
			}
			ListElement {
				fxChannelName: '3'
				fxChannelMidiChannel: 2
			}
			ListElement {
				fxChannelName: '4'
				fxChannelMidiChannel: 3
			}
		}

		Item {
			objectName: 'DJFx Channel %1'.arg(model.fxChannelName)

			FxAssignmentConfig {
				id: fxConfig
				midiChannel: 4
				channelNames: ['Channel1', 'Channel2', 'Channel3', 'Channel4', 'Main']
			}

			DJFxSelect {
				EffectNames {
					id: names
				}
				buttonsModel: ListModel {
					Component.onCompleted: {
						const types = [
							{'note': 0, 'fxName': names.kEcho},
							{'note': 1, 'fxName': names.kFlanger},
							{'note': 2, 'fxName': names.kDelay},
							{'note': 3, 'fxName': names.kPhaser},
						]
						for(const type of types) {
							append({'note': type.note, 'fxName': type.fxName})
						}
					}
				}
			}

			DJFxActivate {
				fxActivateType: FxActivateType.Paddle
				activateControlsModel: ListModel {
					ListElement {
						midiChannel: 4
						note: 4
					}
					ListElement {
						midiChannel: 5
						note: 4
					}
					ListElement {
						midiChannel: 4
						note: 4
					}
					ListElement {
						midiChannel: 5
						note: 4
					}
				}
			}
		}
	}
}


