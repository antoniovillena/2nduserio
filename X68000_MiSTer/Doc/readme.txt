FPGA��X68k�݊��@readme:
�{RTL��DE0-CV(TERASIC��)��FPGA������������
X68000�����̋@�\���������镨�ł��B

�{RTL�Ɋւ��ẮA�t���[�\�t�g�E�F�A�ł��B
�EMC68000 MPU��IP : TG68��Tobias Gubener����ɒ��쌠������܂��B
�E�f�B�X�N�G�~�����[�^�Ɏg�p���Ă���t�H���g�͓��_�t�H���g���I���W�i���ł��B

���̑���RTL�Ɋւ��Ă͎��A�v�[�ɂ���܂��B
����RTL�Ɋ܂܂��t�@�C���Ɋւ��Ă͈�ؖ��ۏ؂ł��B2���I��Q���܂ވ�؂̐ӔC��
�����܂���B

����ُ퓙�Ɋւ��ẮA�u���O
http://fpga8801.seesaa.net/
���̃��b�Z�[�W��R�����g�ɂĘA�������肢�������܂��B

�g�p���@:
�{RTL��Altera�Ђ̊J���� QuartusII web edition�ɂĎ�ɊJ������Ă���A
�{�z�z��QuartusII��archive�@�\�ɂăp�b�P�[�W������Ă���܂��B
�{RTL��Project��Restore archived project�ɂēW�J���s��
(���̃t�@�C�����J���Ă��鎞�_�Ŋ������Ă���Ǝv���܂���)
�R���p�C�����s���܂����A���C�Z���X���̊֌W�ŃR���p�C���ɕK�v�ȃt�@�C����
�������s�����Ă���܂��B
�EBIOS/CGROM.hex
�t�H���g�f�[�^�ł��B���@����z���o�����AWindows�ŃG�~�����[�^�ō쐬�����
CGROM.BIN �܂���CGROM.TMP��intel hex�ɕϊ����Ă��������B
64kB�𒴂��܂�(x86�Ō����Ƃ���̃Z�O�����g�z��)�̂őΉ������ϊ��\�t�g�ŕϊ����Ă��������B

��L�̏������o������Start Compilation�ɂăR���p�C�����s���Ă��������B
�R���p�C��������AFPGA�������pFlash��IPLROM�Ə�ŗp�ӂ���CGROM����������
�������K�v�ɂȂ�܂��B
QuartusII��File��Convert Programming File
����uOpen Vonversion Setup Data...�v���N���b�N���A
X68k_DE0CV.cof
��I�����Ă��������B�X�ɁAAdvanced���N���b�N���ADisable EPCS ID check��
�`�F�b�N�����Ă��������BAdvanced options��OK�ŏI�����A�uGenerate�v��
�N���b�N����ƁAX68k_DE0CV.pof�t�@�C������������܂��̂ł����
Active Serial���[�h��DE0-CV�{�[�h�ɏ������݂��s���Ă��������B

���A�X�C�b�`�Ɋւ��Ă�
�E��d���X�C�b�`�c�{�̂̓d���X�C�b�`�ł��B
�EIPL���Z�b�g�X�C�b�`�c�v�b�V���X�C�b�`�̈�ԍ�(������)
�E�d���X�C�b�`(�O��)�c�v�b�V���X�C�b�`�̑傫�����̂̈�ԉE
�ENMI�X�C�b�`�c�v�b�V���X�C�b�`�̑傫�����̂̉E����2�Ԗ�
10�A�X���C�h�X�C�b�`�̈ꕔ�Ƀf�o�O�p�@�\���ݒ肳��Ă��܂��B
�E����
�E1�Ԗ�:����I(���b)�Ԋu�Ń��Z�b�g
�E3�Ԗ�:CPU PAUSE
�ł��B

SD�J�[�h��SASI HDD�Ɍ�����悤�ɂȂ��Ă��܂��BSDSC(SDHC��SDXC�ł͂Ȃ�
�W���e��)��MicroSD�J�[�h���g�p���Ă��������B
SD�J�[�h�̓t�@�C���V�X�e���ł͂Ȃ��f�B�X�N�Ƃ��Ďg�p���܂��̂œ��e�͏���������A
���̃V�X�e������̃t�@�C�����쓙�͂ł��Ȃ��Ȃ�܂��̂Œ��ӂ��Ă��������B
HDD�Ƃ��Ďg�p���܂��̂œ��쒆�̔��������͂ł��܂���B��d���܂��͓d����
OFF�̏�ԂŔ����������Ă��������B

�⏕�L���Ƃ��Ă�FDD���g�p���܂��B
2015�N���ݓ���\�ȃh���C�u�Ƃ��Ă�3.5"��1.44MB�p(AT�݊��@�p)��
�B��ł͂Ȃ����Ǝv���܂��̂ł��̃h���C�u��ڑ��ł���悤�ɂȂ��Ă���܂��B
X68000�ł͖{�̓�����2�h���C�u�ł��̂�2�h���C�u�ڑ��ł���悤�ɂȂ��Ă���A
�ڑ��ɂ͖{�̂���̐M����AT�݊��@�pFDD�P�[�u��
(2�h���C�u�p�̃R�l�N�^��3�t���Ă���A�ꕔ���P��ꂽ34�c�P�[�u��)
�ɕϊ����Đڑ����邱�ƂɂȂ�܂��B
�ڑ��Ɋւ��ẮA������
pin-assign.xls
���Q�Ƃ��������BPC-8801�łƓ��������ł��̂ł��̂܂܎g�p�ł��܂��B
���f�B�A�Ɋւ��Ă�2HD���f�B�A���g�p���܂��B
FDD��AT�݊��@�p�ł��̂�X68000�ŏ���������FDD�͓ǂݍ��݂ł��Ȃ��Ǝv���܂��B
(X68000:360rpm�AAT:300rpm)
360rpm��FDD(PC-98�p��)��ڑ�����Γǂݍ��݂ł��邩������܂���B
5" 2HD FDD��ڑ�����΁A5"���f�B�A�����̂܂ܓǂݏ����ł��邩������܂���B
(AT�p5" FDD��360rpm�ł��B)

FDD�ւ̃f�[�^�������݂́AVirtual Floppy Image Converter��p����
XDF��D88�ϊ����ADITT��p����3.5" 2HD�ɏ������݂��s���A�����
���삷�邱�Ƃ��m�F���܂����B

SD�J�[�h�ɂ��f�B�X�N�G�~�����[�V�����łɊւ��ẮA�t���̃G�~�����[�^
�����A�udiskemu.txt�v���Q�Ƃ��Ă��������B
�{�@�ł̃��C����ʁE�f�B�X�N�G�~�����[�V������ʂ̐؂�ւ��̓X���C�h�X�C�b�`
SW1�Ɋ��蓖�Ă��Ă��܂��B
