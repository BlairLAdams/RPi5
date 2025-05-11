if (window.mermaid) {
  mermaid.initialize({
    startOnLoad: true,
    theme: 'default',
    themeVariables: {
      fontFamily: 'Roboto, Helvetica Neue, sans-serif',
      fontSize: '16px',
      textColor: '#ffffff',
      primaryColor: '#3f51b5',       // Label background (branch/tag)
      primaryTextColor: '#ffffff',   // Label text color
      primaryBorderColor: '#3f51b5', // Outline
      lineColor: '#bb86fc'           // Arrows and edges
    }
  });
}