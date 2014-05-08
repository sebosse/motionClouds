function saveTightFigure(h,outfilename)
set(gcf,'Units','inches');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
  saveas(h,outfilename);
  system(['pdfcrop ', outfilename,' ', outfilename]);
end