SEARCH_DIR(/lib64/)
SEARCH_DIR(/usr/lib64/)
SEARCH_DIR(./)
SEARCH_DIR(/usr/lib/fpc/2.6.2/units/x86_64-linux/rtl/)
SEARCH_DIR(/usr/bin/)
INPUT(
/usr/lib/fpc/2.6.2/units/x86_64-linux/rtl/prt0.o
"/home/renan/TrabalhoBanin/T1 - Test Generator/Code/TestGenerator.o"
/usr/lib/fpc/2.6.2/units/x86_64-linux/rtl/system.o
ProductHandler.o
StringUtils.o
RealUtils.o
RandomUtils.o
DateTimeUtils.o
ProductUtils.o
SellsUtils.o
MainMenu.o
/usr/lib/fpc/2.6.2/units/x86_64-linux/rtl/crt.o
/usr/lib/fpc/2.6.2/units/x86_64-linux/rtl/sysutils.o
ProductConsultScreen.o
ProductRegisterScreen.o
/usr/lib/fpc/2.6.2/units/x86_64-linux/rtl/objpas.o
/usr/lib/fpc/2.6.2/units/x86_64-linux/rtl/unix.o
/usr/lib/fpc/2.6.2/units/x86_64-linux/rtl/errors.o
/usr/lib/fpc/2.6.2/units/x86_64-linux/rtl/sysconst.o
/usr/lib/fpc/2.6.2/units/x86_64-linux/rtl/unixtype.o
/usr/lib/fpc/2.6.2/units/x86_64-linux/rtl/baseunix.o
/usr/lib/fpc/2.6.2/units/x86_64-linux/rtl/unixutil.o
/usr/lib/fpc/2.6.2/units/x86_64-linux/rtl/syscall.o
/usr/lib/fpc/2.6.2/units/x86_64-linux/rtl/termio.o
InputUtils.o
AboutScreen.o
SellsScreen.o
StatisticsScreen.o
StatisticsFile.o
SellsFile.o
/usr/lib/fpc/2.6.2/units/x86_64-linux/rtl/strutils.o
)
ENTRY(_start)
SECTIONS
{
  PROVIDE (__executable_start = 0x0400000); . = 0x0400000 +  SIZEOF_HEADERS;
  . = 0 +  SIZEOF_HEADERS;
  .interp         : { *(.interp) }
  .hash           : { *(.hash) }
  .dynsym         : { *(.dynsym) }
  .dynstr         : { *(.dynstr) }
  .gnu.version    : { *(.gnu.version) }
  .gnu.version_d  : { *(.gnu.version_d) }
  .gnu.version_r  : { *(.gnu.version_r) }
  .rel.dyn        :
    {
      *(.rel.init)
      *(.rel.text .rel.text.* .rel.gnu.linkonce.t.*)
      *(.rel.fini)
      *(.rel.rodata .rel.rodata.* .rel.gnu.linkonce.r.*)
      *(.rel.data.rel.ro*)
      *(.rel.data .rel.data.* .rel.gnu.linkonce.d.*)
      *(.rel.tdata .rel.tdata.* .rel.gnu.linkonce.td.*)
      *(.rel.tbss .rel.tbss.* .rel.gnu.linkonce.tb.*)
      *(.rel.got)
      *(.rel.bss .rel.bss.* .rel.gnu.linkonce.b.*)
    }
  .rela.dyn       :
    {
      *(.rela.init)
      *(.rela.text .rela.text.* .rela.gnu.linkonce.t.*)
      *(.rela.fini)
      *(.rela.rodata .rela.rodata.* .rela.gnu.linkonce.r.*)
      *(.rela.data .rela.data.* .rela.gnu.linkonce.d.*)
      *(.rela.tdata .rela.tdata.* .rela.gnu.linkonce.td.*)
      *(.rela.tbss .rela.tbss.* .rela.gnu.linkonce.tb.*)
      *(.rela.got)
      *(.rela.bss .rela.bss.* .rela.gnu.linkonce.b.*)
    }
  .rel.plt        : { *(.rel.plt) }
  .rela.plt       : { *(.rela.plt) }
  .init           :
  {
    KEEP (*(.init))
  } =0x90909090
  .plt            : { *(.plt) }
  .text           :
  {
    *(.text .stub .text.* .gnu.linkonce.t.*)
    KEEP (*(.text.*personality*))
    *(.gnu.warning)
  } =0x90909090
  .fini           :
  {
    KEEP (*(.fini))
  } =0x90909090
  PROVIDE (_etext = .);
  .rodata         :
  {
    *(.rodata .rodata.* .gnu.linkonce.r.*)
  }
  . = ALIGN (0x1000) - ((0x1000 - .) & (0x1000 - 1));
  .dynamic        : { *(.dynamic) }
  .got            : { *(.got .toc) }
  .got.plt        : { *(.got.plt .toc.plt) }
  .data           :
  {
    *(.data .data.* .gnu.linkonce.d.*)
    KEEP (*(.fpc .fpc.n_version .fpc.n_links))
    KEEP (*(.gnu.linkonce.d.*personality*))
  }
  PROVIDE (_edata = .);
  PROVIDE (edata = .);
  .threadvar : { *(.threadvar .threadvar.* .gnu.linkonce.tv.*) }
  __bss_start = .;
  .bss            :
  {
   *(.dynbss)
   *(.bss .bss.* .gnu.linkonce.b.*)
   *(COMMON)
   . = ALIGN(32 / 8);
  }
  . = ALIGN(32 / 8);
  PROVIDE (_end = .);
  PROVIDE (end = .);
  .stab          0 : { *(.stab) }
  .stabstr       0 : { *(.stabstr) }
  /* DWARF debug sections.
     Symbols in the DWARF debugging sections are relative to the beginning
     of the section so we begin them at 0.  */
  /* DWARF 1 */
  .debug          0 : { *(.debug) }
  .line           0 : { *(.line) }
  /* GNU DWARF 1 extensions */
  .debug_srcinfo  0 : { *(.debug_srcinfo) }
  .debug_sfnames  0 : { *(.debug_sfnames) }
  /* DWARF 1.1 and DWARF 2 */
  .debug_aranges  0 : { *(.debug_aranges) }
  .debug_pubnames 0 : { *(.debug_pubnames) }
  /* DWARF 2 */
  .debug_info     0 : { *(.debug_info .gnu.linkonce.wi.*) }
  .debug_abbrev   0 : { *(.debug_abbrev) }
  .debug_line     0 : { *(.debug_line) }
  .debug_frame    0 : { *(.debug_frame) }
  .debug_str      0 : { *(.debug_str) }
  .debug_loc      0 : { *(.debug_loc) }
  .debug_macinfo  0 : { *(.debug_macinfo) }
  /* SGI/MIPS DWARF 2 extensions */
  .debug_weaknames 0 : { *(.debug_weaknames) }
  .debug_funcnames 0 : { *(.debug_funcnames) }
  .debug_typenames 0 : { *(.debug_typenames) }
  .debug_varnames  0 : { *(.debug_varnames) }
  /DISCARD/ : { *(.note.GNU-stack) }
}
