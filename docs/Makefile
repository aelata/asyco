# This Makefile only checks whether TARGET files need to be updated.
# Run "Export > HTML > HTML (cdn hosted)" in the preview of VS Code to update.

T={README,INSTALL,asyco,asycat,ISSUES,time}.html
T+=ja/{README,INSTALL,asyco,asycat,ISSUES,time,setup,asy_ja}.html
TARGET=$(shell echo $T)

all: $(TARGET)

%.html: %.md
	@echo $@ is not up-to-date.

clean:
	rm -f $(TARGET)
