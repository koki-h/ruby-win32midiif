#キーボードを押すと音が出ます
require 'sdl'
require 'winMidiIF'
@baseNote = 60 #Aのキーを押したときの音階
@sound    = 0  #音色
@octave   = 0  #オクターブ
def keymap2Note(key)
  case key.sym
  when SDL::Key::A #C
    note = @baseNote + @octave
  when SDL::Key::W #D♭
    note = @baseNote + 1 + @octave
  when SDL::Key::S #D
    note = @baseNote + 2 + @octave
  when SDL::Key::E #D♯
    note = @baseNote + 3 + @octave
  when SDL::Key::D #E
    note = @baseNote + 4 + @octave
  when SDL::Key::F #F
    note = @baseNote + 5 + @octave
  when SDL::Key::T #F♯
    note = @baseNote + 6 + @octave
  when SDL::Key::G #G
    note = @baseNote + 7 + @octave
  when SDL::Key::Y #G♯
    note = @baseNote + 8 + @octave
  when SDL::Key::H #A
    note = @baseNote + 9 + @octave
  when SDL::Key::U #A♯
    note = @baseNote + 10 + @octave
  when SDL::Key::J #B
    note = @baseNote + 11 + @octave
  when SDL::Key::K #C+
    note = @baseNote + 12 + @octave
  end
  note
end

SDL.init( SDL::INIT_VIDEO ) 
#画面初期化
SDL::WM.setCaption("midiInput","")
screen = SDL.setVideoMode( 640, 480, 16, SDL::SWSURFACE ) 
image = SDL::Surface.load( 'surface.bmp' )
image = image.displayFormat
SDL.blitSurface( image, 0, 0, 0, 0, screen, 0, 0 )
screen.updateRect( 0, 0, 0, 0 )

midi = MidiDevice.new
loop do
  midi.changeSound(@sound)
  while event = SDL::Event2.poll
    #音階
    case event 
    when SDL::Event2::Quit 
      exit 
    when SDL::Event2::KeyDown
      #ピッチを上げ下げする
      case event.sym
      when SDL::Key::PAGEUP
        @baseNote += 1
        p "note:" + @baseNote.to_s
      when SDL::Key::PAGEDOWN
        @baseNote -= 1
        p "note:" + @baseNote.to_s
      end
      #音色を変える
      case event.sym
      when SDL::Key::UP
        if @sound < 127
          @sound += 1
        else
          @sound = 0
        end
        p SOUND_LIST[@sound]
      when SDL::Key::DOWN
        if @sound > 0
          @sound -= 1
        else
          @sound = 127
        end
        p SOUND_LIST[@sound]
      end
      #オクターブチェンジ
      case event.sym
      when SDL::Key::LSHIFT 
        @octave -= 12
      when SDL::Key::RSHIFT 
        @octave += 12
      end
      #音を出す
      note = keymap2Note(event)
      midi.playMidiSound(note,127) if note != nil
    when SDL::Event2::KeyUp
      #音を消す
      note = keymap2Note(event)
      midi.stopMidiSound(note,127) if note != nil
      #オクターブチェンジを戻す
      case event.sym
      when SDL::Key::LSHIFT
        midi.allStop
        @octave = 0
      when SDL::Key::RSHIFT
        midi.allStop
        @octave = 0
      end
    end
  end
end
midi.close
