library(aqp)
library(reshape2)
library(latticeExtra)

## http://www.munsellcolourscienceforpainters.com/MunsellResources/SpectralReflectancesOf2007MunsellBookOfColorGlossy.txt

# https://github.com/ncss-tech/aqp/issues/101

# missing odd chroma
x <- read.table('SpectralReflectancesOf2007MunsellBookOfColorGlossy.txt.gz', skip=13, header=TRUE, stringsAsFactors = FALSE, sep=',')

# long format simpler to work with
m <- melt(x, id.vars = 'Name')

# remove leading 'X' from wavelength
m$variable <- as.character(m$variable)
m$v <- as.numeric(gsub(pattern = 'X', replacement = '', x = m$variable))

# subset columns and re-name
m <- m[, c('Name', 'v', 'value')]
names(m) <- c('munsell', 'wavelength', 'reflectance')

# this is clever
# split into Munsell pieces
d <- strcapture(
  '([[[:digit:][:alpha:].]+)([[:digit:]]+)/([[:digit:]]+)', 
  m$munsell, 
  proto = data.frame(hue=character(), value=integer(), chroma=integer(), stringsAsFactors = FALSE)
)

# check: some funky ones in there:
# 10Y8.
# 7.5Y8.
table(d$hue)

# OK
table(d$value)
table(d$chroma)


# re-assemble
m.rel <- data.frame(
  munsell=sprintf("%s %s/%s", d$hue, d$value, d$chroma),
  hue=d$hue, 
  value=d$value, 
  chroma=d$chroma, 
  wavelength=m$wavelength, 
  reflectance=m$reflectance, 
  stringsAsFactors = FALSE
  )

# sort
m.rel <- m.rel[order(m.rel$hue, m.rel$value, m.rel$chroma, m.rel$wavelength), ]


# subset
idx <- which(m.rel$munsell %in% c('10YR 3/4', '7.5YR 4/6'))
s <- m.rel[idx, ]

# idx <- which(m.rel$munsell %in% c('10YR 3/1', '10YR 3/2', '10YR 3/4', '10YR 3/6'))
# s <- m.rel[idx, ]


cols <- parseMunsell(levels(factor(s$munsell)))
tps <- list(superpose.line=list(col=cols, lwd=5))

xyplot(reflectance ~ wavelength, groups=munsell, data=s, 
       type=c('l', 'g'),
       scales=list(tick.number=10),
       auto.key=list(lines=TRUE, points=FALSE, cex=1, space='right'),
       par.settings=tps
)


# long -> wide
s.wide <- dcast(s, munsell ~ wavelength, value.var = 'reflectance')

# mix colors by multiplying spectra (simulate subtractive mixture)
mixed <- s.wide[1, -1] * s.wide[2, -1] 

# probably need to re-scale

# hack to plot mixture...
plot(s$wavelength, s$reflectance, ylim=c(0, 0.25))
lines(as.numeric(names(unlist(mixed))), unlist(mixed) * 10, col='red')



## investigate slices -- can interpolate reflectance vs chroma (by wavelengths) for odd chroma

idx <- which(m.rel$hue %in% c('7.5YR') & m.rel$value == 4)
s <- m.rel[idx, ]

xyplot(reflectance ~ chroma | factor(wavelength), data=s, 
       type='b', as.table=TRUE,
       scales=list(tick.number=10),
       auto.key=list(lines=TRUE, points=FALSE, cex=1, space='right')
)




