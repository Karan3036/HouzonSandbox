export default function portalSyndicationData({ amountOfRecords }) {
  return [...Array(amountOfRecords)].map((_, index) => {
    return {
      Id: `aei${index}`,
      name: `Portal (${index})`,
      status: `inactive`,
      buttonColor: "brand",
      buttonLabel: "Publish"
    };
  });
}