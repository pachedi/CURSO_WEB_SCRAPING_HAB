

static <- read_html("https://www.forbes.com/top-colleges/")

static %>% html_elements(".CustomTable_container__CkQ96")


sess <- read_html_live("https://www.forbes.com/top-colleges/")

sess$view()

rows <- sess %>% html_elements(".CustomTable_container__CkQ96") %>% 
  html_table()

tabla <- as.data.frame(rows)

rows %>% html_element(".TopColleges2023_organizationName__J1lEV") %>% html_text()

rows %>% html_element(".grant-aid") %>% html_text()
