require 'Win32API'
class MidiDevice
  def initialize
    #API�֐����C���|�[�g
    #�f�o�C�X�I�[�v��
    midiOutOpen = Win32API.new('winmm','midiOutOpen','PPLLL','L')
    #���b�Z�[�W�𑗐M
    @midiOutShortMsg = Win32API.new('winmm','midiOutShortMsg','LP','L')
    @midiOutReset = Win32API.new('winmm','midiOutReset','P','L')
    @midiOutClose = Win32API.new('winmm','midiOutClose','P','V')
    
    #�f�o�C�X�̃A�h���X���擾
    midiPtrBuff = "    " #�|�C���^�Ɋi�[���ꂽ�l���󂯎�邽�߂̃o�b�t�@�̈�i�|�C���^�̃T�C�Y��4�o�C�g�j
    midiOutOpen.call(midiPtrBuff,0,0,0,0)
    @ptr = midiPtrBuff.unpack("I")[0] #������^�Ŗ߂��Ă����l�𐔒l�ɕϊ�
  end
  def playMidiSound(note,vol)
    data = []
    data[0] = 0x90 + 0 # �������b�Z�[�W + �`�����l��
    data[1] = note     # �m�[�g�ԍ�
    data[2] = vol      # ����
    data[3] =   0      # �g���Ȃ�
    msg = data.pack("CCCC").unpack("i")[0] #�z��̊e�v�f���S�o�C�g�ϐ��̊e�o�C�g�Ɋ��蓖��
    @midiOutShortMsg.call(@ptr,msg)   # ���b�Z�[�W�𑗐M
  end
  def stopMidiSound(note,vol)
    data = []
    data[0] = 0x80 + 0 # �������b�Z�[�W + �`�����l��
    data[1] = note     # �m�[�g�ԍ�
    data[2] = vol      # ����
    data[3] = 0        # �g���Ȃ�
    msg = data.pack("CCCC").unpack("i")[0] #�z��̊e�v�f���S�o�C�g�ϐ��̊e�o�C�g�Ɋ��蓖��
    @midiOutShortMsg.call(@ptr,msg)   # ���b�Z�[�W�𑗐M
  end
  def changeSound(soundId)
    data = []
    data[0] = 0xC0 + 0 # �������b�Z�[�W + �`�����l��
    data[1] = soundId  # ���F�ԍ�
    data[2] = 0        # �g���Ȃ�
    data[3] = 0        # �g���Ȃ�
    msg = data.pack("CCCC").unpack("i")[0] #�z��̊e�v�f���S�o�C�g�ϐ��̊e�o�C�g�Ɋ��蓖��
    @midiOutShortMsg.call(@ptr,msg)   # ���b�Z�[�W�𑗐M
  end
  def allStop()
    @midiOutReset.call(@ptr)
  end
  def close
    @midiOutClose.call(@ptr)
  end
end
#���F���X�g
SOUND_LIST = {
  0x00 => "Acoustic Grand Piano",
  0x01 => "Bright Acoustic Piano",
  0x02 => "Electric Grand Piano",
  0x03 => "Honkey-tonk Piano",
  0x04 => "Electric Piano1",
  0x05 => "Electric Piano2",
  0x06 => "Harpsichord",
  0x07 => "Clavi",
  0x08 => "Celesta",
  0x09 => "Glockenspiel",
  0x0A => "Music Box",
  0x0B => "Vibraphone",
  0x0C => "Marinmba",
  0x0D => "Xylophone",
  0x0E => "Tubular Bells",
  0x0F => "Dulcimer",
  0x10 => "Drawbar Organ",
  0x11 => "Percussive Organ",
  0x12 => "Rock Organ",
  0x13 => "Church Organ",
  0x14 => "Reed Organ",
  0x15 => "Accordion",
  0x16 => "Harmonica",
  0x17 => "Tango Accordion",
  0x18 => "Acoustic Guitar(nylon)",
  0x19 => "Acoustic Guitar(steel)",
  0x1A => "Electric Guitar(jazz)",
  0x1B => "Electric Guitar(clean)",
  0x1C => "Electric Guitar(muted)",
  0x1D => "Overdriven Guitar",
  0x1E => "Distortion Guitar",
  0x1F => "Guitar harmonics",
  0x20 => "Acoustic Bass",
  0x21 => "Electric Bass(finger)",
  0x22 => "Electric Bass(pick)",
  0x23 => "Fretless Bass",
  0x24 => "Slap Bass1",
  0x25 => "Slap Bass2",
  0x26 => "Synth Bass1",
  0x27 => "Synth Bass2",
  0x28 => "Violin",
  0x29 => "Viola",
  0x2A => "Cello",
  0x2B => "Contrabass",
  0x2C => "Tremolo Strings",
  0x2D => "Pizzicato Strings",
  0x2E => "Orchestral Harp",
  0x2F => "Timpani",
  0x30 => "String Emsemble1",
  0x31 => "String Emsemble2",
  0x32 => "Synth String1",
  0x33 => "Synth String2",
  0x34 => "Choir Aahs",
  0x35 => "Voice Oohs",
  0x36 => "Synth Vox",
  0x37 => "Orchestra Hit",
  0x38 => "Trumpet",
  0x39 => "Trombone",
  0x3A => "Tuba",
  0x3B => "Muted Trumpet",
  0x3C => "French Horn",
  0x3D => "Brass Section",
  0x3E => "Synth Brass1",
  0x3F => "Synth Brass2",
  0x40 => "Soprano Sax",
  0x41 => "Alto Sax",
  0x42 => "Tenor Sax",
  0x43 => "Baritone Sax",
  0x44 => "Oboe",
  0x45 => "English Horn",
  0x46 => "Bossoon",
  0x47 => "Clarinet",
  0x48 => "Piccolo",
  0x49 => "Flute",
  0x4A => "Recorder",
  0x4B => "Pan Flute",
  0x4C => "Blown Bottle",
  0x4D => "Shakuhachi",
  0x4E => "Whistle",
  0x4F => "Ocarina",
  0x50 => "Lead1(square)",
  0x51 => "Lead2(sawtooth)",
  0x52 => "Lead3(calliope)",
  0x53 => "Lead4(chiff)",
  0x54 => "Lead5(charang)",
  0x55 => "Lead6(voice)",
  0x56 => "Lead7(fifths)",
  0x57 => "Lead8(bass + lead)",
  0x58 => "Pad1(new age)",
  0x59 => "Pad2(warm)",
  0x5A => "Pad3(polysynth)",
  0x5B => "Pad4(choir)",
  0x5C => "Pad5(bowed)",
  0x5D => "Pad6(metallic)",
  0x5E => "Pad7(halo)",
  0x5F => "Pad8(sweep)",
  0x60 => "Fx1(rain)",
  0x61 => "Fx2(soundtrack)",
  0x62 => "Fx3(crystal)",
  0x63 => "Fx4(atmosphere)",
  0x64 => "Fx5(brightness)",
  0x65 => "Fx6(goblins)",
  0x66 => "Fx7(echoes)",
  0x67 => "Fx8(sci-fi)",
  0x68 => "Sitar",
  0x69 => "Banjo",
  0x6A => "Shamisen",
  0x6B => "Koto",
  0x6C => "Kalimba",
  0x6D => "Bag pipe",
  0x6E => "Fiddle",
  0x6F => "Shanai",
  0x70 => "Tinkle Bell",
  0x71 => "Agogo",
  0x72 => "Steel Drums",
  0x73 => "Woodblock",
  0x74 => "Taiko",
  0x75 => "Melodic Tom",
  0x76 => "Synth Drum",
  0x77 => "Reverse Cymbal",
  0x78 => "Guitar Fret Noise",
  0x79 => "Breath Noise",
  0x7A => "Seashore",
  0x7B => "Bird Tweet",
  0x7C => "Telephone Ring",
  0x7D => "Helicopter",
  0x7E => "Applause",
  0x7F => "Gunshot"
}
#�e�X�g
if __FILE__ == $0
midi = MidiDevice.new
#midi.playMidiSound(60,127)#�m�[�g�ԍ�(60=�h)
#sleep(1) # ��������
#midi.playMidiSound(62,127)#�m�[�g�ԍ�(62=��)
#sleep(1) # ��������
#midi.playMidiSound(64,127)#�m�[�g�ԍ�(64=�~)
#sleep(1) # ��������
#midi.playMidiSound(65,127)#�m�[�g�ԍ�(65=�t�@)
#sleep(1) # ��������
#midi.playMidiSound(67,127)#�m�[�g�ԍ�(67=�\)
#sleep(1) # ��������
#midi.playMidiSound(69,127)#�m�[�g�ԍ�(69=��)
#sleep(1) # ��������
#midi.playMidiSound(71,127)#�m�[�g�ԍ�(71=�V)
#sleep(1) # ��������
#midi.playMidiSound(72,127)#�m�[�g�ԍ�(72=�h)
sleep(1) # ��������
#�a��
midi.changeSound(50)
midi.playMidiSound(60,127)#�m�[�g�ԍ�(60=�h)
sleep(1) # ��������
midi.playMidiSound(64,127)#�m�[�g�ԍ�(64=�~)
sleep(1) # ��������
midi.playMidiSound(67,127)#�m�[�g�ԍ�(67=�\)
sleep(1) # ��������
midi.playMidiSound(72,127)#�m�[�g�ԍ�(72=�h)
sleep(1) # ��������
midi.stopMidiSound(72,127)
midi.close
end
