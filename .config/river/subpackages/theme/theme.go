package theme

import (
	"log"
	"os"

	"gopkg.in/yaml.v3"
)

type Theme struct {
	SchemeName   string `yaml:"scheme-name"`
	SchemeAuthor string `yaml:"scheme-author"`
	Colors       struct {
		Base00 string `yaml:"base00"`
		Base01 string `yaml:"base01"`
		Base02 string `yaml:"base02"`
		Base03 string `yaml:"base03"`
		Base04 string `yaml:"base04"`
		Base05 string `yaml:"base05"`
		Base06 string `yaml:"base06"`
		Base07 string `yaml:"base07"`
		Base08 string `yaml:"base08"`
		Base09 string `yaml:"base09"`
		Base0A string `yaml:"base0A"`
		Base0B string `yaml:"base0B"`
		Base0C string `yaml:"base0C"`
		Base0D string `yaml:"base0D"`
		Base0E string `yaml:"base0E"`
		Base0F string `yaml:"base0F"`
	} `yaml:"colors"`
}

//	func GetTheme(filename string) (*Theme, error) {
//		buf, err := os.ReadFile(filename)
//		if err != nil {
//			return nil, err
//		}
//
//		c := &Theme{}
//		err = yaml.Unmarshal(buf, c)
//		if err != nil {
//			return nil, fmt.Errorf("in file %q: %w", filename, err)
//		}
//
//		return c, err
//	}

func (t *Theme) GetTheme(filename string) *Theme {

	yamlFile, err := os.ReadFile(filename)
	if err != nil {
		log.Printf("yamlFile.Get err   #%v ", err)
	}
	err = yaml.Unmarshal(yamlFile, t)
	if err != nil {
		log.Fatalf("Unmarshal: %v", err)
	}

	return t
}

//func (theme *Theme) GetTheme(path string) *Theme {
//
//	yamlFile, err := os.ReadFile(path)
//	if err != nil {
//		log.Printf("yamlFile.Get err   #%v ", err)
//	}
//
//	err = yaml.Unmarshal(yamlFile, theme)
//	if err != nil {
//		log.Fatalf("Unmarshal: %v", err)
//	}
//
//	return theme
//}
