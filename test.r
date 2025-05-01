add <- function(x, y) {
  x + y
}

hello <- rnorm(100)

#region

print(add(1, -2))
print(add(1.0e10, 2.0e10))

#endregion

print(paste("one", NULL))
print(paste(NA, 'two'))

print(paste("multi-
line",
'multi-
line'))


x<-seq(1,10)
y<-seq(2,11)

plot(x, y)