module.exports = {
  pathPrefix: "/foss4g-nor-web",
  siteMetadata: {
    title: "FOSS4GNO",
    description: "En konferanse om open-source programvare i geomatikkbransjen",
    author: "Faggruppen Geografisk IT i Geoforum",
    siteUrl: `https://www.foss4g.no`
  },
  plugins: [
    `gatsby-plugin-react-helmet`,
    `gatsby-plugin-styled-components`,
    `gatsby-plugin-offline`,
    `gatsby-transformer-sharp`,
    `gatsby-plugin-sharp`,
    `gatsby-image`,
    {
      resolve: `gatsby-plugin-sitemap`
    },
    {
      resolve: `gatsby-source-filesystem`,
      options: {
        name: `data`,
        path: `${__dirname}/src/data/`,
      },
    },
    {
      resolve: `gatsby-source-filesystem`,
      options: {
        name: `sponsorimages`,
        path: `${__dirname}/src/assets/sponsorimages/`,
      },
    },
    {
      resolve: `gatsby-source-filesystem`,
      options: {
        name: `speakerimages`,
        path: `${__dirname}/src/assets/speakerimages/`,
      },
    },
    {
    resolve: `gatsby-transformer-csv`,
      options: {
        trim:true
      }
    }
  ]
};
