
<!-- README.md is generated from README.Rmd. Please edit that file -->

# flair <a href='http://kbodwin.github.io/flair/index.html'><img src='man/figures/flair_hex.png' align="right" height="139" /></a>

<!-- badges: start -->

<!-- [![CRAN checks](https://cranchecks.info/badges/worst/flair)](https://cran.r-project.org/web/checks/check_results_flair.html) -->

[![Travis build
status](https://travis-ci.org/kbodwin/flair.svg?branch=master)](https://travis-ci.org/kbodwin/flair)
<!-- badges: end -->

The goal of flair is to is to provide tools for formatting R code in
knitted R Markdown files.

## Installation

<!-- You can install the released version of flair from [CRAN](https://CRAN.R-project.org) with: -->

<!-- ``` r -->

<!-- install.packages("flair") -->

<!-- ``` -->

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("kbodwin/flair")
```

## Introduction

``` r
library(flair)
library(dplyr)
library(ggplot2)
```

**Important**:  This ReadMe shows the basic usage, but the resultant formatting cannot be displayed outside of an html document.  Please reference the Pkgdown site at [https://kbodwin.github.io/flair/index.html](https://kbodwin.github.io/flair/index.html) for full examples.

It is common to show source code, in addition to code output, as part of
a conference talk, workshop, or lecture. Often, we want to call
attention to certain aspects of the code.

For example, suppose you want to illustrate to a new learner the use of
the pipe `%>%`. You might want to create a slide that shows the
following:

<pre class='sourceCode r'><code>iris %>%
<br>&nbsp;&nbsp;group_by(Species) %>%
<br>&nbsp;&nbsp;summarize(mean(Sepal.Length))</code></pre>

but with the pipes highlighted for emphasis.

``` 

#> # A tibble: 3 x 2
#>   Species    `mean(Sepal.Length)`
#>   <fct>                     <dbl>
#> 1 setosa                     5.01
#> 2 versicolor                 5.94
#> 3 virginica                  6.59
```

Without `flair`, your approach might be to type your code into your code
chunk, copy-paste it to a string, and manually format that string using
html to add the background highlighting to the pipes. What a headache\!

### Decorating a code chunk

The cleanest way to add flair to your code is to reference a named code
chunk in R Markdown.

For example, your code chunk might look like:

```` 

```{r how_to_pipe, include = FALSE}

iris %>%
  group_by(Species) %>%
  summarize(mean(Sepal.Length))

```
````

We would use the `decorate()` function, referencing our chunk named
`how_to_pipe` to prepare the source code for decoration. Then we could
use the function `flair()` to show our source code with the pipe
operators highlighted in yellow.

```` 

```{r, echo = FALSE}

decorate("how_to_pipe") %>% 
  flair("%>%")
  
```
````

Note that the `decorate` and `flair` step should be in a separate chunk,
since it is not itself part of the source code you wish to decorate.


#### Re-referencing a chunk

A nice consequence of using the chunk label approach to `flair` is that
the same chunk can be displayed multiple times, with different flair
decorations, without needing to retype the original code.

For example, you might want to create multiple slides to reference the various 
elements of a code chunk.  Your source code chunks might look like:

``` r
decorate("how_to_pipe") %>% 
  flair_funs()
```

``` r
decorate("how_to_pipe") %>% 
  flair_args()
```


### Decorating code from a text string

You can also use the `decorate` function to add flair to R code supplied
directly as a string. For example

``` r
decorate('

iris %>%
  group_by(Species) %>%
  summarize(mean(Sepal.Length))

') %>%
  flair("%>%")
```

For the most part, we do not recommend this option, as it is more
difficult to pre-test your code in string from than in a true chunk.

However, this option is particularly nice if you want to show “bad” code
that cannot normally be evaluated. For example:

``` r
decorate('mean(1:10',
         error = TRUE) %>%
  flair("(")
```

<pre class='sourceCode r'><code>mean<span style='background-color:#ffff7f'>(</span>1:10</code></pre>

``` 

#> Error: <text>:2:0: unexpected end of input
#> 1: mean(1:10
#>    ^
```

### Being specific with `decorate`

The function `decorate` does its best to tell when it is receiving input
of a chunk label versus code-as-text. However, in the event that
something goes awry, you can always be explicit by using functions
`decorate_code()` and `decorate_chunk()`

``` r
decorate_code('mean(1:10)') %>%
  flair("(")
```

``` r
decorate_chunk('how_to_pipe') %>%
  flair("%>%")
```

## The `flair_*` functions

The advantage of a `decorate_code` object is that you can add formatting
to the source code without altering the output. This decorative
formatting is specified through the suite of `flair` functions

### flair

The main function you will use is simply `flair()`. This takes as
arguments:

  - A `flair` object or a text string.

  - A fixed string pattern to match

  - Any number of formatting parameters

If no formatting parameters are supplied, `flair_*` will default to
ordinary yellow-background highlighting.

`flair` returns a `decorate_code` object, so it is pipe friendly\!

Refer back to the `how_to_pipe` chunk above. Suppose you want to
highlight the pipe operator (`%>%`) in yellow, highlight the variable
name `Sepal.Length` in pink, and change the text color of `Species` to
blue

``` r
decorate('how_to_pipe') %>%
  flair("%>%") %>%
  flair("Sepal.Length", background = "pink") %>%
  flair("Species", color = "CornflowerBlue")
```


### flair\_rx

The function `flair_rx` takes pattern matching input in the form of a
regular expression, rather than a fixed string.

(In fact, all `flair_*` functions are built on `flair_rx`.)

### Syntax highlighting

`flair` also includes a few shortcuts for highlighting specific aspects
of R source code. Currently, these functions are:

  - `flair_funs()` for *functions*

  - `flair_args()` for *arguments to functions*

  - `flair_input_vals()` for *values assigned to function arguments*

For example:

``` r
decorate('
ggplot(iris, aes(x = Sepal.Length, 
                y = Petal.Length, 
                color = Species)) +
  geom_point()

') %>%
  flair_args(color = "CornflowerBlue") %>%
  flair_funs(color = "Coral", underline = TRUE) %>%
  flair_input_vals(background = "Aquamarine") %>%
  flair_rx("[A-z]*\\.Length", background = "pink")
```

## Errata

### Evaluating code and defining objects

One nice feature the `decorate` function is that it evaluates the
referenced code when it is run. This means that you can define objects
in your source code, and use them later in your analysis as you normally
would:

``` r
decorate('foo <- mean(1:10)') %>% 
  flair_funs()
```

<pre class='sourceCode r'><code>foo <- <span style='background-color:#ffff7f'>mean</span>(1:10)</code></pre>

``` r
foo + 5
```

    #> [1] 10.5

A word of caution: Make sure you define your objects in your code
string, not outside the `decorate()` function\! For example, the
following approach has two problems:

1.  `foo` contains the output object itself, rather than the result of
    the R code `mean(1:10)`, so `foo + 5` throws an error.

2.  The output object of `decorate` is being assigned to `foo` rather
    than printed, so no highlighted code is included in the knitted
    output.

<!-- end list -->

``` r
foo <- decorate('mean(1:10)') %>% 
  flair_funs()

foo + 5
```

    #> Error in foo + 5: non-numeric argument to binary operator

### A note about colors

`flair` gives you complete freedom to choose the colors of your
highlighted elements, so long as the color name is a [recognized html
name](https://www.w3schools.com/colors/colors_names.asp) or a hex code.

However, please remember to be judicious in your color choices, and to
keep in mind [how your colors appear to colorblind
individuals](https://venngage.com/blog/color-blind-friendly-palette/).
